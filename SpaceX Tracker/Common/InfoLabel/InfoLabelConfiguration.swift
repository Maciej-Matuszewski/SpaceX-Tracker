//
//  InfoLabelConfiguration.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

enum InfoLabelConfiguration: Equatable {
    case mission(name: String)
    case date(date: Date)
    case rocket(name: String, type: String)
    case daysSinceNow(date: Date)
}
