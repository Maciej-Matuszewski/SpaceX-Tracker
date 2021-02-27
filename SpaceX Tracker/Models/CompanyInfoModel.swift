//
//  CompanyInfoModel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct CompanyInfoModel: Codable {
    let id: String
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let launchSites: Int
    let valuation: Double
}
