//
//  Date+CurrentYear.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation

extension Date {
    static func currentYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }
}
