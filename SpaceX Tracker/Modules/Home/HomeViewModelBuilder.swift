//
//  HomeViewModelBuilder.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct HomeViewModelBuilder {
    static func build(with state: HomeInteractor.State, dateFormatter: DateFormatter) -> HomeViewModel {
        .init(
            sections: [
                HomeViewModel.Section(
                    headerTitle: Localized.HomeViewModelBuilder.Headers.company,
                    items: [companyInfoItem(with: state)].compactMap({ $0 }),
                    footer: companyInfoFooter(with: state)
                ),
                HomeViewModel.Section(
                    headerTitle: Localized.HomeViewModelBuilder.Headers.launches,
                    items: launchItems(with: state, dateFormatter: dateFormatter),
                    footer: launchesFooter(with: state)
                ),
            ]
        )
    }

    private static func companyInfoItem(with state: HomeInteractor.State) -> HomeViewModel.Item? {
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
    }

    private static func companyInfoFooter(with state: HomeInteractor.State) -> HomeViewModel.Footer {
        if let error = state.companyInfoError { return .emptyState(error.localizedDescription) }
        if state.companyInfoModel == nil { return .loadingIndicator }
        return .none
    }

    private static func launchItems(with state: HomeInteractor.State, dateFormatter: DateFormatter) -> [HomeViewModel.Item] {
        state.launchModels.map { (model) -> HomeViewModel.Item in
            .launch(
                viewModel: LaunchCellViewModel(
                    missionImageURL: model.links.missionPatchSmall ?? "",
                    statusImage: model.upcoming ? .waiting : model.launchSuccess == true ? .success : .failed,
                    missionLabelViewModel: InfoLabelViewModelBuilder.build(
                        with: .mission(name: model.missionName),
                        dateFormatter: dateFormatter
                    ),
                    dateLabelViewModel: InfoLabelViewModelBuilder.build(
                        with: .date(date: model.launchDateLocal),
                        dateFormatter: dateFormatter
                    ),
                    rocketLabelViewModel: InfoLabelViewModelBuilder.build(
                        with: .rocket(name: model.rocket.rocketName, type: model.rocket.rocketType),
                        dateFormatter: dateFormatter
                    ),
                    daysSinceNowLabelViewModel: InfoLabelViewModelBuilder.build(
                        with: .daysSinceNow(date: model.launchDateLocal),
                        dateFormatter: dateFormatter
                    )
                )
            )
        }
    }

    private static func launchesFooter(with state: HomeInteractor.State) -> HomeViewModel.Footer {
        if let error = state.launchesError { return .emptyState(error.localizedDescription) }
        if state.hasNextPage { return .loadingIndicator }
        if state.launchModels.isEmpty { return .emptyState(Localized.HomeViewModelBuilder.emptyStateLaunches) }
        return .none
    }
}
