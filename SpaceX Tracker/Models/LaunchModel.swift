//
//  CompanyInfoModel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct LaunchModel: Codable {
    struct Rocket: Codable {
        let rocketName: String
        let rocketType: String
    }

    struct Links: Codable {
        let missionPatch: String?
        let missionPatchSmall: String?
        let articleLink: String?
        let wikipedia: String?
        let videoLink: String?
    }

    let missionName: String
    let rocket: Rocket
    let launchSuccess: Bool?
    let upcoming: Bool
    let launchDateLocal: Date
    let links: Links
}
