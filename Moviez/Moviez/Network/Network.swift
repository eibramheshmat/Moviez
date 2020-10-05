//
//  Network.swift
//  Aaraa
//
//  Created by Mina Malak on 6/17/19.
//  Copyright © 2019 Mina Malak. All rights reserved.
//  Network class using URLSessionRequest.

import Foundation

class Network{
    static let shared = Network()
    
    private let config: URLSessionConfiguration
    private let session: URLSession
    
    private init() {
        config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func request<T: Decodable>(router: Router, model: T, completion: @escaping (Result<T,ErrorType>) -> ()) {
        do {
            let task = try session.dataTask(with: router.request()) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        completion(.failure(.serverError))
                        return
                    }
                    guard let statusCode = urlResponse?.getStatusCode(), (200...299).contains(statusCode) else {
                        let errorType: ErrorType
                        switch urlResponse?.getStatusCode() {
                        case 404:
                            errorType = .notFound
                        case 422:
                            errorType = .validationError
                        case 500:
                            errorType = .serverError
                        default:
                            errorType = .defaultError
                        }
                        completion(.failure(errorType))
                        return
                    }
                    guard let data = data else {
                        completion(.failure(.defaultError))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    } catch _ {
                        completion(.failure(.defaultError))
                    }
                }
            }
            task.resume()
        } catch _ {
            completion(.failure(.defaultError))
        }
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
