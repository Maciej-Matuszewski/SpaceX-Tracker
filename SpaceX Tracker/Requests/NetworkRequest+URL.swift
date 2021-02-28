//
//  NetworkRequest+URL.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation
import Network

extension NetworkRequest {
    var url: URL? {
        URL.init(string: "https://api.spacexdata.com/v3")
    }
}
