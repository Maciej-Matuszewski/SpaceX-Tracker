//
//  CompanyInfoRequest.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation
import Network

struct LaunchesRequest: NetworkRequest {
    let path: String = "launches"
    let method: NetworkClient.HTTPMethod = .GET
    let parameters: [String : String]

    init(page: Int = 0, filters: Filters) {
        let limit = 30
        var parameters: [String : String] = [
            "limit": "\(limit)",
            "offset": "\(limit * page)"
        ]

        parameters["order"] = filters.order == .ascending ? "asc" : "desc"

        switch filters.status {
        case .all: break
        case .successful: parameters["launch_success"] = "true"
        case .unsuccessful: parameters["launch_success"] = "false"
        }

        parameters["start"] = "\(filters.yearFrom)-01-01"
        parameters["end"] = "\(filters.yearTo)-12-31"

        self.parameters = parameters
    }
}
