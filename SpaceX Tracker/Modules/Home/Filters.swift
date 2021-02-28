//
//  Filters.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation

struct Filters {
    enum Order: String {
        case ascending = "Ascending"
        case descending = "Descending"

        var index: Int {
            switch self {
            case .ascending: return 0
            case .descending: return 1
            }
        }
    }

    enum Status: String {
        case all = "All"
        case successful = "Successful"
        case unsuccessful = "Unsuccessful"

        var index: Int {
            switch self {
            case .all: return 0
            case .successful: return 1
            case .unsuccessful: return 2
            }
        }
    }

    var order: Order
    var status: Status
    var yearFrom: Int
    var yearTo: Int
}
