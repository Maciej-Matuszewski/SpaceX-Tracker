//
//  CompanyInfoRequest.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation
import Network

struct CompanyInfoRequest: NetworkRequest {
    let path: String = "info"
    let method: NetworkClient.HTTPMethod = .GET
    let parameters: [String : String] = [:]
}
