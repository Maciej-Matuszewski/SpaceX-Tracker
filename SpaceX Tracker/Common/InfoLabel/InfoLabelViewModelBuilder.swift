//
//  InfoLabelViewModelBuilder.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct InfoLabelViewModelBuilder {
    static func build(with configuration: InfoLabelConfiguration) -> (title: String, value: String) {
        switch configuration {
        case .mission(let name):
            return (title: "Mission:", value: name)

        case .date(let date):
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .medium
            dateFormater.timeStyle = .none
            let day = dateFormater.string(from: date)

            dateFormater.dateStyle = .none
            dateFormater.timeStyle = .short
            let time = dateFormater.string(from: date)

            return (title: "Date/Time:", value: "\(day) at \(time)")

        case .rocket(let name, let type):
            return (title: "Rocket: ", value: "\(name)/\(type)")

        case .daysSinceNow(let date):
            let now = Date()
            let title: String = {
                if date.compare(now) == .orderedAscending {
                    return "Days since now:"
                }
                return "Days from now:"
            }()
            let value: String = {
                let secondsInDay: Double = 86400
                let numberOfDays = Int(round(abs(date.timeIntervalSince(now)/secondsInDay)))

                return "\(numberOfDays) \(numberOfDays == 1 ? "Day" : "Days")"
            }()

            return (title: title, value: value)
        }
    }
}
