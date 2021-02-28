//
//  SpaceX_TrackerTests.swift
//  SpaceX TrackerTests
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import XCTest
import Network
@testable import SpaceX_Tracker

class HomeViewModelBuilderTests: XCTestCase {
    func test_initialState() {
        // Given state
        let state: HomeInteractor.State = .fake()

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.first?.items.count, 0)
        XCTAssertEqual(viewModel.sections.first?.headerTitle, "Company")
        XCTAssertEqual(viewModel.sections.first?.footer, .loadingIndicator)

        XCTAssertEqual(viewModel.sections.last?.items.count, 0)
        XCTAssertEqual(viewModel.sections.last?.headerTitle, "Launches")
        XCTAssertEqual(viewModel.sections.last?.footer, .loadingIndicator)
    }

    func test_companyInfo_loaded() {
        // Given state
        let state: HomeInteractor.State = .fake(
            companyInfoModel: .init(
                name: "Pepsi",
                founder: "Jerry",
                founded: 1995,
                employees: 3,
                launchSites: 20,
                valuation: 200
            )
        )

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.first?.items.count, 1)
        XCTAssertEqual(viewModel.sections.first?.headerTitle, "Company")
        XCTAssertEqual(viewModel.sections.first?.footer, HomeViewModel.Footer.none)

        guard case .companyInfo(let cellViewModel) = viewModel.sections.first?.items.first else {
            return XCTFail("Incorect type of item")
        }

        XCTAssertEqual(
            cellViewModel.labelText,
            "Pepsi was founded by Jerry in 1995. It has now 3 employees, 20 launch sites, and is valued at USD 200.00."
        )
    }

    func test_companyInfo_errorOccured() {
        // Given state
        let state: HomeInteractor.State = .fake(
            companyInfoModel: nil,
            companyInfoError: NetworkError.invalidData
        )

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.first?.items.count, 0)
        XCTAssertEqual(viewModel.sections.first?.headerTitle, "Company")
        XCTAssertEqual(viewModel.sections.first?.footer, HomeViewModel.Footer.emptyState("Problem with server data has occured. Please try again later."))
    }

    func test_launches_loaded() {
        // Given state
        let state: HomeInteractor.State = .fake(
            launchModels: [
                .fake(
                    missionName: "mission_1",
                    rocket: .init(rocketName: "rocket_name", rocketType: "rocket_type"),
                    launchSuccess: true,
                    launchDateLocal: .distantPast
                ),
                .fake(
                    missionName: "mission_2",
                    launchSuccess: false
                ),
                .fake(
                    missionName: "mission_3",
                    launchSuccess: nil,
                    upcoming: true,
                    launchDateLocal: .distantFuture
                )
            ],
            hasNextPage: false
        )

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.last?.items.count, 3)
        XCTAssertEqual(viewModel.sections.last?.headerTitle, "Launches")
        XCTAssertEqual(viewModel.sections.last?.footer, HomeViewModel.Footer.none)

        guard case .launch(let cellViewModel0) = viewModel.sections.last?.items[0] else {
            return XCTFail("Incorect type of item")
        }

        XCTAssertEqual(cellViewModel0.missionLabelConfiguration, .mission(name: "mission_1"))
        XCTAssertEqual(cellViewModel0.dateLabelConfiguration, .date(date: .distantPast))
        XCTAssertEqual(cellViewModel0.rocketLabelConfiguration, .rocket(name: "rocket_name", type: "rocket_type"))
        XCTAssertEqual(cellViewModel0.daysSinceNowLabelConfiguration, .daysSinceNow(date: .distantPast))
        XCTAssertEqual(cellViewModel0.statusImage, .success)

        guard case .launch(let cellViewModel1) = viewModel.sections.last?.items[1] else {
            return XCTFail("Incorect type of item")
        }

        XCTAssertEqual(cellViewModel1.missionLabelConfiguration, .mission(name: "mission_2"))
        XCTAssertEqual(cellViewModel1.statusImage, .failed)

        guard case .launch(let cellViewModel2) = viewModel.sections.last?.items[2] else {
            return XCTFail("Incorect type of item")
        }

        XCTAssertEqual(cellViewModel2.missionLabelConfiguration, .mission(name: "mission_3"))
        XCTAssertEqual(cellViewModel2.dateLabelConfiguration, .date(date: .distantFuture))
        XCTAssertEqual(cellViewModel2.statusImage, .waiting)
    }

    func test_launches_loaded_hasNextPage() {
        // Given state
        let state: HomeInteractor.State = .fake(
            launchModels: [
                .fake(missionName: "mission_1"),
                .fake(missionName: "mission_2"),
                .fake(missionName: "mission_3")
            ],
            hasNextPage: true
        )

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.last?.items.count, 3)
        XCTAssertEqual(viewModel.sections.last?.headerTitle, "Launches")
        XCTAssertEqual(viewModel.sections.last?.footer, HomeViewModel.Footer.loadingIndicator)
    }

    func test_launches_loaded_emptyState() {
        // Given state
        let state: HomeInteractor.State = .fake(
            launchModels: [],
            hasNextPage: false
        )

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.last?.items.count, 0)
        XCTAssertEqual(viewModel.sections.last?.headerTitle, "Launches")
        XCTAssertEqual(viewModel.sections.last?.footer, HomeViewModel.Footer.emptyState("There is no record of launches for provided filters."))
    }

    func test_launches_errorOccured() {
        // Given state
        let state: HomeInteractor.State = .fake(
            launchModels: [],
            launchesError: NetworkError.invalidData
        )

        // When builder will prepare viewModel
        let viewModel = HomeViewModelBuilder.build(with: state)

        // Then
        XCTAssertEqual(viewModel.sections.count, 2)

        XCTAssertEqual(viewModel.sections.last?.items.count, 0)
        XCTAssertEqual(viewModel.sections.last?.headerTitle, "Launches")
        XCTAssertEqual(viewModel.sections.last?.footer, HomeViewModel.Footer.emptyState("Problem with server data has occured. Please try again later."))
    }
}

fileprivate extension HomeInteractor.State {
    static func fake(
        companyInfoModel: CompanyInfoModel? = nil,
        companyInfoError: Error? = nil,
        launchModels: [LaunchModel] = [],
        launchesError: Error? = nil,
        currentPage: Int = 0,
        isFetching: Bool = false,
        hasNextPage: Bool = true,
        filters: Filters = .fake()
    ) -> HomeInteractor.State {
        .init(
            companyInfoModel: companyInfoModel,
            companyInfoError: companyInfoError,
            launchModels: launchModels,
            launchesError: launchesError,
            currentPage: currentPage,
            isFetching: isFetching,
            hasNextPage: hasNextPage,
            filters: filters
        )
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

fileprivate extension Filters {
    static func fake(
        order: Filters.Order = .ascending,
        status: Filters.Status = .all,
        yearFrom: Int = 2016,
        yearTo: Int = 2022
    ) -> Filters {
        .init(order: order, status: status, yearFrom: yearFrom, yearTo: yearTo)
    }
}
