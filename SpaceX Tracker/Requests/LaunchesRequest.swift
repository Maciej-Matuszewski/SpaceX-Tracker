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

    init(page: Int = 0) {
        let limit = 30
        parameters = [
            "limit": "\(limit)",
            "offset": "\(limit * page)"
        ]
    }
}
