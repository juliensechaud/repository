//
//  NetworkLayer.swift
//  Repository
//
//  Created by Julien Sechaud on 05/10/2020.
//

import Foundation

// Fetch API Rest
// Connector -> connected
// GET / POST / UPDATE / OPTIONS / DELETE
// Error mgt

struct User: Decodable {
    let name: String?
    let birthdate: Date?
}

enum HTTPMethod {
    case get
    case post
    case put
    case delete
    case options
    
    var stringValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .options:
            return "OPTIONS"
        }
    }
}

// URLSession

class NetworkLayer {
    
    private let urlSession: URLSession!
    
    init(configuration: URLSessionConfiguration = .default) {
        urlSession = URLSession(configuration: configuration,
                                delegate: nil,
                                delegateQueue: nil)
    }
    
    private func request(url: URL,
                         method: HTTPMethod,
                         callback: ((Result<Decodable, Error>) -> Void)?) {
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 60.0)
        urlRequest.httpMethod = method.stringValue
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            
            guard let httpURLResponse = response as? HTTPURLResponse else {
                callback?(.failure(error))
            }
            
            if let error = error {
                callback?(.failure(error))
            }
        }
    }
}
