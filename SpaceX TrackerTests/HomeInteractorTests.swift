//
//  SpaceX_TrackerTests.swift
//  SpaceX TrackerTests
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import XCTest
import Network
@testable import SpaceX_Tracker

class HomeInteractorTests: XCTestCase {
    struct Context: NetworkClientProvider & DateFormatterProvider {
        let networkClient: NetworkClientProtocol = NetworkClientMock()
        let dateFormatter = DateFormatter()
    }

    private var mockDelegate: HomeInteractorDelegateMock!
    private var interactor: HomeInteractor!
    private var context: Context!

    override func setUp() {
        super.setUp()
        mockDelegate = .init()
        context = .init()
        interactor = .init(context: context)
        interactor.delegate = mockDelegate
    }

    override func tearDown() {
        mockDelegate.clear()
        mockDelegate = nil
        context = nil
        interactor = nil
        super.tearDown()
    }

    func test_updateViewModel() {
        let exp = expectation(description: "Waiting for invocations update")
        exp.expectedFulfillmentCount = 2
        mockDelegate.onUpdateCallback = {
            exp.fulfill()
        }

        interactor.initialFetch()

        wait(for: [exp], timeout: 2.0)

        XCTAssertEqual(
            mockDelegate.invocations,
            [.didUpdateViewModel, .didUpdateViewModel]
        )
    }

    func test_showFilters() {
        let exp = expectation(description: "Waiting for invocations update")
        exp.expectedFulfillmentCount = 1
        mockDelegate.onUpdateCallback = {
            exp.fulfill()
        }

        interactor.showActionForFilterButton()

        wait(for: [exp], timeout: 2.0)

        XCTAssertEqual(
            mockDelegate.invocations,
            [.wantsToShowFilters]
        )
    }

    func test_showOptions() {
        let exp1 = expectation(description: "Waiting for invocations update")
        exp1.expectedFulfillmentCount = 2
        mockDelegate.onUpdateCallback = {
            exp1.fulfill()
        }

        interactor.initialFetch()
        wait(for: [exp1], timeout: 2.0)


        let exp2 = expectation(description: "Waiting for invocations update")
        exp2.expectedFulfillmentCount = 1
        mockDelegate.onUpdateCallback = {
            exp2.fulfill()
        }

        interactor.showActionForItem(at: .init(row: 0, section: 1))

        wait(for: [exp2], timeout: 2.0)

        XCTAssertEqual(
            mockDelegate.invocations,
            [.didUpdateViewModel, .didUpdateViewModel, .wantsToShowOptions]
        )
    }
}

fileprivate class NetworkClientMock: NetworkClientProtocol {
    func send<T>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T : Decodable, T : Encodable {

        switch request.self {
        case is CompanyInfoRequest:
            completion(
                .success(
                    CompanyInfoModel(
                        name: "Pepsi",
                        founder: "Jerry",
                        founded: 1995,
                        employees: 3,
                        launchSites: 20,
                        valuation: 200
                    ) as! T
                )
            )

        case is LaunchesRequest:
            completion(
                .success(
                    [
                        LaunchModel.fake(missionName: "Mission_1" ),
                        LaunchModel.fake(missionName: "Mission_2" )
                    ] as! T
                )
            )

        default: completion(.failure(NetworkError.invalidURL))
        }
        return nil
    }
}

fileprivate extension LaunchModel {
    static func fake(
        missionName: String = "",
        rocket: Rocket = .init(rocketName: "", rocketType: ""),
        launchSuccess: Bool? = nil,
        upcoming: Bool = false,
        launchDateLocal: Date = Date.distantPast,
        links: Links = .init(missionPatch: nil, missionPatchSmall: nil, articleLink: nil, wikipedia: nil, videoLink: nil)
    ) -> LaunchModel {
        .init(
            missionName: missionName,
            rocket: rocket,
            launchSuccess: launchSuccess,
            upcoming: upcoming,
            launchDateLocal: launchDateLocal,
            links: links
        )
    }
}
