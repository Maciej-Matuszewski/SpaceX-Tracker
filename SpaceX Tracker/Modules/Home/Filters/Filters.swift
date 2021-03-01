//
//  Filters.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation

struct Filters {
    enum Order: String {
        case ascending
        case descending

        var index: Int {
            switch self {
            case .ascending: return 0
            case .descending: return 1
            }
        }

        var rawValue: String {
            switch self {
            case .ascending: return Localized.Filters.Order.ascending
            case .descending: return Localized.Filters.Order.descending
            }
        }
    }

    enum Status: String {
        case all
        case successful
        case unsuccessful

        var index: Int {
            switch self {
            case .all: return 0
            case .successful: return 1
            case .unsuccessful: return 2
            }
        }

        var rawValue: String {
            switch self {
            case .all: return Localized.Filters.Status.all
            case .successful: return Localized.Filters.Status.successful
            case .unsuccessful: return Localized.Filters.Status.unsuccessful
            }
        }
    }

    static let minYear: Int = 2006
    static let maxYear: Int = Date.currentYear() + 2

    var order: Order
    var status: Status
    var yearFrom: Int
    var yearTo: Int
}
