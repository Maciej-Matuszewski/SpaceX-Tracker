//
//  InfoLabelViewModelBuilder.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct InfoLabelViewModelBuilder {
    static func build(with configuration: InfoLabelConfiguration, dateFormatter: DateFormatter) -> InfoLabelViewModel {
        switch configuration {
        case .mission(let name):
            return .init(title: Localized.InfoLabel.Title.mission, value: name)

        case .date(let date):
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let day = dateFormatter.string(from: date)

            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            let time = dateFormatter.string(from: date)

            return .init(
                title: Localized.InfoLabel.Title.date,
                value: Localized.InfoLabel.Value.date(day: day, time: time)
            )

        case .rocket(let name, let type):
            return .init(title: Localized.InfoLabel.Title.rocket, value: "\(name)/\(type)")

        case .daysSinceNow(let date):
            let now = Date()
            let title: String = {
                if date.compare(now) == .orderedAscending {
                    return Localized.InfoLabel.Title.daysSince
                }
                return Localized.InfoLabel.Title.daysFrom
            }()
            let value: String = {
                let secondsInDay: Double = 86400
                let numberOfDays = Int(round(abs(date.timeIntervalSince(now)/secondsInDay)))

                return "\(numberOfDays) \(numberOfDays == 1 ? Localized.InfoLabel.Value.day : Localized.InfoLabel.Value.days)"
            }()

            return .init(title: title, value: value)
        }
    }
}
