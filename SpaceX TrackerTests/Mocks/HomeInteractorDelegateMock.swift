//
//  HomeInteractorDelegateMock.swift
//  SpaceX TrackerTests
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation
@testable import SpaceX_Tracker

final class HomeInteractorDelegateMock: HomeInteractorDelegate {
    enum Invocation {
        case didUpdateViewModel
        case wantsToShowError
        case wantsToShowWebsite
        case wantsToShowFilters
        case wantsToShowOptions
    }

    var onUpdateCallback: (() -> Void)?

    private(set) var invocations: [Invocation] = [] {
        didSet {
            print(invocations)
            onUpdateCallback?()
        }
    }

    func interactor(_ interactor: HomeInteractor, didUpdateViewModel viewModel: HomeViewModel) {
        invocations.append(.didUpdateViewModel)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowError error: Error) {
        invocations.append(.wantsToShowError)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowWebsiteWithURL url: URL) {
        invocations.append(.wantsToShowWebsite)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowFiltersViewController filtersViewController: FiltersViewController) {
        invocations.append(.wantsToShowFilters)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowOptionsViewController optionsViewController: OptionsAlertControler) {
        invocations.append(.wantsToShowOptions)
    }

    func clear() {
        onUpdateCallback = nil
        invocations.removeAll()
    }
}
