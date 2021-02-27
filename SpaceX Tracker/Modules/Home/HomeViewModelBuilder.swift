//
//  HomeViewModelBuilder.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct HomeViewModelBuilder {
    static func initial() -> HomeViewModel {
        .init(
            sections: [
                HomeViewModel.Section(
                    headerTitle: "Company",
                    items: [],
                    isLoading: true
                ),
                HomeViewModel.Section(
                    headerTitle: "Launches",
                    items: [],
                    isLoading: true
                ),
            ]
        )
    }

    static func build(with state: HomeInteractor.State) -> HomeViewModel {
        let companyInfoItem: HomeViewModel.Item? = {
            guard let model = state.companyInfoModel else { return nil }
            let text = "\(model.name) was founded by \(model.founder) in \(model.founded). It has now \(model.employees) employees, \(model.launchSites) launch sites, and is valued at USD \(model.valuation)."
            return .companyInfo(viewModel: .init(labelText: text))
        }()

        return .init(
            sections: [
                HomeViewModel.Section(
                    headerTitle: "Company",
                    items: [companyInfoItem].compactMap({ $0 }),
                    isLoading: state.companyInfoModel == nil
                ),
                HomeViewModel.Section(
                    headerTitle: "Launches",
                    items: [],
                    isLoading: true
                ),
            ]
        )
    }
}
