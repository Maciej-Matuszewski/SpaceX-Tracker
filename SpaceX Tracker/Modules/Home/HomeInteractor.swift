//
//  HomeInteractor.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation
import Network

protocol HomeInteractorDelegate: class {
    func interactor(_ interactor: HomeInteractor, didUpdateViewModel viewModel: HomeViewModel)
    func interactor(_ interactor: HomeInteractor, wantsToShowError error: Error)
    func interactor(_ interactor: HomeInteractor, wantsToShowWebsiteWithURL url: URL)
}

final class HomeInteractor {
    struct State {
        var companyInfoModel: CompanyInfoModel?
        var launchModels: [LaunchModel]
        var currentPage: Int = 0
        var isFetching: Bool = false
        var hasNextPage: Bool = true

        mutating func update(companyInfoModel: CompanyInfoModel?) {
            self.companyInfoModel = companyInfoModel
        }

        mutating func update(launchModels: [LaunchModel], hasNextPage: Bool) {
            self.launchModels = launchModels
            self.currentPage = 0
            self.hasNextPage = hasNextPage
            self.isFetching = false
        }

        mutating func append(launchModels: [LaunchModel], page: Int, hasNextPage: Bool) {
            self.launchModels.append(contentsOf: launchModels)
            self.currentPage = page
            self.hasNextPage = hasNextPage
            self.isFetching = false
        }
    }

    private var state: State = .init(companyInfoModel: nil, launchModels: []) {
        didSet {
            viewModel = HomeViewModelBuilder.build(with: state)
        }
    }

    private (set) var viewModel: HomeViewModel = HomeViewModelBuilder.initial() {
        didSet {
            delegate?.interactor(self, didUpdateViewModel: viewModel)
        }
    }

    weak var delegate: HomeInteractorDelegate?

    private var networkClient = NetworkClient()

    func fetchData() {
        fetchCompanyInfo()
        fetchLaunches(page: 0)
    }

    func fetchNextPage() {
        fetchLaunches(page: state.currentPage + 1)
    }

    private func fetchCompanyInfo() {
        networkClient.send(request: CompanyInfoRequest()) { [weak self] (result: Result<CompanyInfoModel, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state.update(companyInfoModel: model)
            case .failure(let error):
                self.delegate?.interactor(self, wantsToShowError: error)
            }
        }
    }

    private func fetchLaunches(page: Int) {
        guard !state.isFetching, state.hasNextPage else { return }
        state.isFetching = true
        print("Fetch for page: \(page)")
        networkClient.send(request: LaunchesRequest(page: page)) { [weak self] (result: Result<[LaunchModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                if page == 0 {
                    self.state.update(launchModels: models, hasNextPage: !models.isEmpty)
                } else {
                    self.state.append(launchModels: models, page: page, hasNextPage: !models.isEmpty)
                }
            case .failure(let error):
                self.delegate?.interactor(self, wantsToShowError: error)
            }
        }
    }

    func showActionForItem(at indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let model = state.launchModels[indexPath.row]
        guard let url = URL(string: model.links.videoLink ?? "") else { return }
        delegate?.interactor(self, wantsToShowWebsiteWithURL: url)
    }
}
