//
//  AppContext.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation
import Network

struct AppContext {
    let networkClient: NetworkClientProtocol = NetworkClient()
    let imageDownloader: ImageDownloaderProtocol = ImageDownloader()
    let dateFormatter: DateFormatter = DateFormatter()
}

protocol NetworkClientProvider {
    var networkClient: NetworkClientProtocol { get }
}
extension AppContext: NetworkClientProvider { }

protocol ImageDownloaderProvider {
    var imageDownloader: ImageDownloaderProtocol { get }
}
extension AppContext: ImageDownloaderProvider { }

protocol DateFormatterProvider {
    var dateFormatter: DateFormatter { get }
}
extension AppContext: DateFormatterProvider { }

