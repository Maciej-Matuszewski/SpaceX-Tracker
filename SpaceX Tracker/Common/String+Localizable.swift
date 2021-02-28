//
//  String+Localizable.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}

struct Localized {
    struct InfoLabel {
        struct Title {
            static let mission = "INFO_LABEL_TITLE_MISSION".localized()
            static let date = "INFO_LABEL_TITLE_DATE".localized()
            static let rocket = "INFO_LABEL_TITLE_ROCKET".localized()
            static let daysSince = "INFO_LABEL_TITLE_DAYS_SINCE".localized()
            static let daysFrom = "INFO_LABEL_TITLE_DAYS_FROM".localized()
        }

        struct Value {
            static func date(day: String, time: String) -> String {
                String(format: "INFO_LABEL_VALUE_DATE".localized(), day, time)
            }
            static let day = "INFO_LABEL_VALUE_DAY".localized()
            static let days = "INFO_LABEL_VALUE_DAYS".localized()
        }
    }

    struct HomeViewController {
        struct ErrorAlert {
            static let title = "HOME_VIEW_CONTROLLER_ERROR_ALERT_TITLE".localized()
            static let buttonOk = "HOME_VIEW_CONTROLLER_ERROR_ALERT_BUTTON_OK".localized()
            static let buttonRetry = "HOME_VIEW_CONTROLLER_ERROR_ALERT_BUTTON_RETRY".localized()
        }

        static let title = "HOME_VIEW_CONTROLLER_TITLE".localized()
    }

    struct HomeViewModelBuilder {
        struct Headers {
            static let company = "HOME_VIEW_MODEL_BUILDER_HEADER_COMPANY".localized()
            static let launches = "HOME_VIEW_MODEL_BUILDER_HEADER_LAUNCHES".localized()
        }
        static func companyInfo(
            companyName: String,
            founderName: String,
            year: Int,
            employees: Int,
            launchSites: Int,
            valuation: Double
        ) -> String {
            String(
                format: "HOME_VIEW_MODEL_BUILDER_COMPANY_INFO".localized(),
                companyName,
                founderName,
                year,
                employees,
                launchSites,
                valuation
            )
        }
        static let emptyStateLaunches = "HOME_VIEW_MODEL_BUILDER_EMPTY_STATE_LAUNCHES".localized()
    }

    struct FiltersViewController {
        struct Headers {
            static let order = "FILTERS_VIEW_CONTOLLER_HEADERS_ORDER".localized()
            static let status = "FILTERS_VIEW_CONTOLLER_HEADERS_STATUS".localized()
            static let launchYears = "FILTERS_VIEW_CONTOLLER_HEADERS_LAUNCH_YEARS".localized()
        }

        struct Buttons {
            static let update = "FILTERS_VIEW_CONTOLLER_BUTTONS_UPDATE".localized()
            static let cancel = "FILTERS_VIEW_CONTOLLER_BUTTONS_CANCEL".localized()
        }
    }

    struct Filters {
        struct Order {
            static let ascending = "FILTERS_ORDER_ASCENDING".localized()
            static let descending = "FILTERS_ORDER_DESCENDING".localized()
        }

        struct Status {
            static let all = "FILTERS_STATUS_ALL".localized()
            static let successful = "FILTERS_STATUS_SUCCESSFUL".localized()
            static let unsuccessful = "FILTERS_STATUS_UNSUCESSFUL".localized()
        }
    }

    struct Options {
        static let article = "OPTIONS_ARTICLE".localized()
        static let wikipedia = "OPTIONS_WIKIPEDIA".localized()
        static let youtube = "OPTIONS_YOUTUBE".localized()
        static let cancel = "OPTIONS_CANCEL".localized()
    }

    struct NetworkError {
        static let invalidURL = "NETWORK_ERROR_INVALID_URL".localized()
        static let invalidData = "NETWORK_ERROR_INVALID_DATA".localized()
    }
}
