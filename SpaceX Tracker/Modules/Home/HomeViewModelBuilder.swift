//
//  HomeViewModelBuilder.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct HomeViewModelBuilder {
    static func build(with state: HomeInteractor.State) -> HomeViewModel {
        let companyInfoItem: HomeViewModel.Item? = {
            guard let model = state.companyInfoModel else { return nil }
            let text = Localized.HomeViewModelBuilder.companyInfo(
                companyName: model.name,
                founderName: model.founder,
                year: model.founded,
                employees: model.employees,
                launchSites: model.launchSites,
                valuation: model.valuation
            )
            return .companyInfo(viewModel: .init(labelText: text))
        }()

        let companyInfoFooter: HomeViewModel.Footer = {
            if let error = state.companyInfoError {
                return .emptyState(error.localizedDescription)
            }

            if state.companyInfoModel == nil {
                return .loadingIndicator
            }

            return .none
        }()

        let launchItems = state.launchModels.map { (model) -> HomeViewModel.Item in
            .launch(
                viewModel: LaunchCellViewModel(
                    missionImageURL: model.links.missionPatchSmall ?? "",
                    statusImage: model.upcoming ? .waiting : model.launchSuccess == true ? .success : .failed,
                    missionLabelConfiguration: .mission(name: model.missionName),
                    dateLabelConfiguration: .date(date: model.launchDateLocal),
                    rocketLabelConfiguration: .rocket(name: model.rocket.rocketName, type: model.rocket.rocketType),
                    daysSinceNowLabelConfiguration: .daysSinceNow(date: model.launchDateLocal)
                )
            )
        }

        let launchesFooter: HomeViewModel.Footer = {
            if let error = state.launchesError {
                return .emptyState(error.localizedDescription)
            }

            if state.hasNextPage {
                return .loadingIndicator
            }

            if state.launchModels.isEmpty {
                return .emptyState(Localized.HomeViewModelBuilder.emptyStateLaunches)
            }

            return .none
        }()

        return .init(
            sections: [
                HomeViewModel.Section(
                    headerTitle: Localized.HomeViewModelBuilder.Headers.company,
                    items: [companyInfoItem].compactMap({ $0 }),
                    footer: companyInfoFooter
                ),
                HomeViewModel.Section(
                    headerTitle: Localized.HomeViewModelBuilder.Headers.launches,
                    items: launchItems,
                    footer: launchesFooter
                ),
            ]
        )
    }
}
