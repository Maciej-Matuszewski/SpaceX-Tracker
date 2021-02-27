//
//  CompanyInfoRequest.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation
import Network

struct CompanyInfoRequest: NetworkRequest {
    var path: String = "company"
    var method: NetworkClient.HTTPMethod = .GET
    var parameters: [String : String] = [:]
}
