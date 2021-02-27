//
//  NetworkClient.swift
//  
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation

public final class NetworkClient {
    public init() {}

    public enum NetworkError: Error {
        case invalidURL
        case invalidData
    }

    public enum HTTPMethod: String{
        case GET
        case POST
        case PUT
    }

    private let session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        return session
    }()

    @discardableResult
    public func send<T: Codable>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        guard let request = request.urlRequest else {
            completion(.failure(NetworkError.invalidURL))
            return nil
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.sync { completion(.failure(error)) }
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard
                let data = data,
                let model = try? decoder.decode(T.self, from: data)
            else {
                DispatchQueue.main.sync { completion(.failure(NetworkError.invalidData)) }
                return
            }

            DispatchQueue.main.sync { completion(.success(model)) }
        }
        task.resume()
        return task
    }
}
