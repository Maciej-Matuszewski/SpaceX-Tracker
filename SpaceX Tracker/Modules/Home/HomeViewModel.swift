//
//  HomeViewModel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

struct HomeViewModel {
    enum CellIdentifier: String {
        case companyInfo = "company_info_cell"
        case launch = "launch_cell"
    }

    enum Item {
        case companyInfo(viewModel: CompanyInfoCellViewModel)
        case launch(viewModel: LaunchCellViewModel)

        var cellIdentifier: CellIdentifier {
            switch self {
            case .companyInfo: return .companyInfo
            case .launch: return .launch
            }
        }
    }

    struct Section {
        let headerTitle: String
        let items: [Item]
        let isLoading: Bool
    }

    let sections: [Section]
}
