//
//  NetworkClient.swift
//  
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

public protocol NetworkClientProtocol {
    @available(iOS 10.0, *)
    @discardableResult
    func send<T: Codable>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask?
}

public enum NetworkError: Error {
    case invalidURL
    case invalidData
}

public final class NetworkClient: NetworkClientProtocol {
    public init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        }
    }

    public enum HTTPMethod: String{
        case GET
        case POST
        case PUT
    }

    private(set) var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        return session
    }()

    @available(iOS 10.0, *)
    @discardableResult
    public func send<T: Codable>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        guard let request = request.urlRequest else {
            completion(.failure(NetworkError.invalidURL))
            return nil
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard
                let data = data,
                let model = try? decoder.decode(T.self, from: data)
            else {
                DispatchQueue.main.async { completion(.failure(NetworkError.invalidData)) }
                return
            }

            DispatchQueue.main.async { completion(.success(model)) }
        }
        task.resume()
        return task
    }
}
