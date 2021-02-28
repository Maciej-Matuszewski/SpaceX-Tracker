//
//  HomeViewModel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct HomeViewModel: Equatable {
    enum CellIdentifier: String {
        case companyInfo = "company_info_cell"
        case launch = "launch_cell"
    }

    enum Item: Equatable {
        case companyInfo(viewModel: CompanyInfoCellViewModel)
        case launch(viewModel: LaunchCellViewModel)

        var cellIdentifier: CellIdentifier {
            switch self {
            case .companyInfo: return .companyInfo
            case .launch: return .launch
            }
        }
    }

    enum Footer: Equatable {
        case loadingIndicator
        case emptyState(String)
        case none
    }

    struct Section: Equatable {
        let headerTitle: String
        let items: [Item]
        let footer: Footer
    }

    let sections: [Section]
}
