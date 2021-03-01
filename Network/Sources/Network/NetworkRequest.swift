//
//  NetworkRequest.swift
//  
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

public protocol NetworkRequest {
    var baseURL: URL? { get }
    var path: String { get }
    var method: NetworkClient.HTTPMethod { get }
    var parameters: [String : String] { get }
}

extension NetworkRequest {
    var urlRequest: URLRequest? {
        guard let baseURL = baseURL,
              var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else { return nil }

        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
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
