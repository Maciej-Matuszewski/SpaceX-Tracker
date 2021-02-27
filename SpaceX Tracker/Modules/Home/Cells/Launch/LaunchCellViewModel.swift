//
//  LaunchCellViewModel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct LaunchCellViewModel {
    enum StatusImage {
        case success
        case failed
        case waiting
    }

    let missionImageURL: URL
    let statusImage: StatusImage
    let missionLabelConfiguration: InfoLabelConfiguration
    let dateLabelConfiguration: InfoLabelConfiguration
    let rocketLabelConfiguration: InfoLabelConfiguration
    let daysSinceNowLabelConfiguration: InfoLabelConfiguration
}
