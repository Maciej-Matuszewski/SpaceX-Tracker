//
//  LaunchCellViewModel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//
import Foundation

struct LaunchCellViewModel: Equatable {
    enum StatusImage {
        case success
        case failed
        case waiting
    }

    let missionImageURL: String
    let statusImage: StatusImage
    let missionLabelViewModel: InfoLabelViewModel
    let dateLabelViewModel: InfoLabelViewModel
    let rocketLabelViewModel: InfoLabelViewModel
    let daysSinceNowLabelViewModel: InfoLabelViewModel
}
