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
}

final class HomeInteractor {
    struct State {
        var companyInfoModel: CompanyInfoModel?

        mutating func update(companyInfoModel: CompanyInfoModel?) {
            self.companyInfoModel = companyInfoModel
        }
    }

    private var state: State = .init(companyInfoModel: nil) {
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

    var networkClient = NetworkClient()

    func fetchData() {
        networkClient.send(request: CompanyInfoRequest()) { [weak self] (result: Result<CompanyInfoModel, Error>) in
            switch result {
            case .success(let model):
                self?.state.update(companyInfoModel: model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
