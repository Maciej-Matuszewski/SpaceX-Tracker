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
    func interactor(_ interactor: HomeInteractor, wantsToShowAlert alertBuilder: AlertBuilder)
    func interactor(_ interactor: HomeInteractor, wantsToShowFiltersViewController filtersViewController: FiltersViewController)
}

final class HomeInteractor {
    typealias Context = NetworkClientProvider

    private let context: Context
    weak var delegate: HomeInteractorDelegate?
    private var currentDataTask: URLSessionTask?

    struct State {
        var companyInfoModel: CompanyInfoModel?
        var launchModels: [LaunchModel]
        var currentPage: Int = 0
        var isFetching: Bool = false
        var hasNextPage: Bool = true
        var filters: Filters = .init(order: .ascending, status: .all, yearFrom: 2006, yearTo: Date.currentYear() + 2)

        mutating func set(_ filters: Filters) {
            self.filters = filters
            launchModels.removeAll()
            currentPage = 0
            isFetching = false
            hasNextPage = true
        }

        mutating func update(launchModels: [LaunchModel], page: Int, hasNextPage: Bool) {
            if page == 0 { self.launchModels.removeAll()  }
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

    private (set) lazy var viewModel: HomeViewModel = HomeViewModelBuilder.build(with: state) {
        didSet {
            delegate?.interactor(self, didUpdateViewModel: viewModel)
        }
    }


    init(context: Context) {
        self.context = context
    }

    func fetchData() {
        fetchCompanyInfo()
        fetchLaunches(page: 0)
    }

    func fetchNextPage() {
        fetchLaunches(page: state.currentPage + 1)
    }

    private func fetchCompanyInfo() {
        context.networkClient.send(request: CompanyInfoRequest()) { [weak self] (result: Result<CompanyInfoModel, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state.companyInfoModel = model
            case .failure(let error):
                self.delegate?.interactor(self, wantsToShowError: error)
            }
        }
    }

    private func fetchLaunches(page: Int) {
        guard !state.isFetching, state.hasNextPage else { return }
        state.isFetching = true
        currentDataTask = context.networkClient.send(
            request: LaunchesRequest(
                page: page,
                filters: state.filters
            )
        ) { [weak self] (result: Result<[LaunchModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                self.state.update(launchModels: models, page: page, hasNextPage: !models.isEmpty)
            case .failure(let error):
                self.delegate?.interactor(self, wantsToShowError: error)
            }
        }
    }

    func showActionForFilterButton() {
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        filtersViewController.configure(with: state.filters)
        delegate?.interactor(self, wantsToShowFiltersViewController: filtersViewController)
    }

    func showActionForItem(at indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let model = state.launchModels[indexPath.row]
        guard let url = URL(string: model.links.videoLink ?? "") else { return }
        delegate?.interactor(self, wantsToShowWebsiteWithURL: url)
    }
}

extension HomeInteractor: FiltersViewControllerDelegate {
    func viewController(_ viewController: FiltersViewController, wantsToUpdateFilters filters: Filters) {
        currentDataTask?.cancel()
        state.set(filters)
        fetchLaunches(page: 0)
    }
}
