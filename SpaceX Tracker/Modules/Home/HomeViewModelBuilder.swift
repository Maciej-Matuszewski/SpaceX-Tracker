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
}
