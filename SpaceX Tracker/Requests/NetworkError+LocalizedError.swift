//
//  NetworkError+LocalizedError.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import Foundation
import Network

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return Localized.NetworkError.invalidURL
        case .invalidData: return Localized.NetworkError.invalidData
        }
    }
}
