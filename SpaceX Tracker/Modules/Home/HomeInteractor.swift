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
    func interactor(_ interactor: HomeInteractor, wantsToShowFiltersViewController filtersViewController: FiltersViewController)
    func interactor(_ interactor: HomeInteractor, wantsToShowOptionsViewController optionsViewController: OptionsAlertControler)
}

final class HomeInteractor {
    typealias Context = NetworkClientProvider

    private let context: Context
    weak var delegate: HomeInteractorDelegate?
    private var currentDataTask: URLSessionTask?

    struct State {
        private(set) var companyInfoModel: CompanyInfoModel?
        private(set) var companyInfoError: Error?
        private(set) var launchModels: [LaunchModel]
        private(set) var launchesError: Error?
        private(set) var currentPage: Int = 0
        var isFetching: Bool = false
        private(set) var hasNextPage: Bool = true
        private(set) var filters: Filters = .init(order: .ascending, status: .all, yearFrom: 2006, yearTo: Date.currentYear() + 2)

        mutating func set(filters: Filters) {
            self.filters = filters
            launchModels.removeAll()
            currentPage = 0
            isFetching = false
            hasNextPage = true
        }

        mutating func set(companyInfoModel: CompanyInfoModel?, error: Error? = nil) {
            self.companyInfoModel = companyInfoModel ?? self.companyInfoModel
            self.companyInfoError = error
        }

        mutating func set(launchModels: [LaunchModel], page: Int, hasNextPage: Bool, error: Error? = nil) {
            if page == 0 { self.launchModels.removeAll()  }
            self.launchModels.append(contentsOf: launchModels)
            self.currentPage = page
            self.hasNextPage = hasNextPage
            self.isFetching = false
            self.launchesError = error
        }

        mutating func clear() {
            companyInfoModel = nil
            companyInfoError = nil
            launchModels = []
            launchesError = nil
            currentPage = 0
            isFetching = false
            hasNextPage = true
        }
    }

    private var state: State = .init(companyInfoModel: nil, launchModels: []) {
        didSet {
            viewModel = HomeViewModelBuilder.build(with: state)
        }
    }

    private (set) lazy var viewModel: HomeViewModel = HomeViewModelBuilder.build(with: state) {
        didSet {
            guard oldValue != viewModel else { return }
            delegate?.interactor(self, didUpdateViewModel: viewModel)
        }
    }


    init(context: Context) {
        self.context = context
    }

    func initialFetch() {
        currentDataTask?.cancel()
        state.clear()
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
                self.state.set(companyInfoModel: model)
            case .failure(let error):
                self.state.set(companyInfoModel: nil, error: error)
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
                self.state.set(launchModels: models, page: page, hasNextPage: !models.isEmpty)
            case .failure(let error):
                self.state.set(launchModels: [], page: page, hasNextPage: false, error: error)
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

        let optionsViewController = OptionsAlertControler(title: model.missionName, message: nil, preferredStyle: .actionSheet)
        optionsViewController.delegate = self

        if let url = URL(string: model.links.articleLink ?? "") {
            optionsViewController.addAction(title: Localized.Options.article, url: url)
        }

        if let url = URL(string: model.links.wikipedia ?? "") {
            optionsViewController.addAction(title: Localized.Options.wikipedia, url: url)
        }

        if let url = URL(string: model.links.videoLink ?? "") {
            optionsViewController.addAction(title: Localized.Options.youtube, url: url)
        }

        delegate?.interactor(self, wantsToShowOptionsViewController: optionsViewController)
    }
}

extension HomeInteractor: FiltersViewControllerDelegate {
    func viewController(_ viewController: FiltersViewController, wantsToUpdateFilters filters: Filters) {
        currentDataTask?.cancel()
        state.set(filters: filters)
        fetchLaunches(page: 0)
    }
}

extension HomeInteractor: OptionsAlertControlerDelegate {
    func alertController(_ alertController: OptionsAlertControler, wantsToShowWebsiteWithURL url: URL) {
        delegate?.interactor(self, wantsToShowWebsiteWithURL: url)
    }
}
