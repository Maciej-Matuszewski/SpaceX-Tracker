//
//  NetworkRequest.swift
//  
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

public protocol NetworkRequest {
    var path: String { get }
    var method: NetworkClient.HTTPMethod { get }
    var parameters: [String : String] { get }
}

extension NetworkRequest {
    var url: URL? {
        URL.init(string: "https://api.spacexdata.com/v4")
    }

    var urlRequest: URLRequest? {
        guard let baseURL = url,
              var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else { return nil }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
