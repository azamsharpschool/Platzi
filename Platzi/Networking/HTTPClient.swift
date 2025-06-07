//
//  HTTPClient.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import Foundation

protocol HTTPClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T
}

enum Endpoint {
    case categories
    
    var url: URL {
        let base = "https://api.escuelajs.co/api/v1"
        
        switch self {
        case .categories:
            return URL(string: "\(base)/categories")!
        }
    }
}

enum NetworkError: Error {
    case badRequest
    case decodingError(Error)
    case invalidResponse
    case errorResponse(ErrorResponse)
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "badRequestError")
        case .decodingError(let error):
            return NSLocalizedString("Unable to decode successfully. \(error)", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response.", comment: "invalidResponse")
        case .errorResponse(let errorResponse):
            return NSLocalizedString("Error \(errorResponse.message ?? "")", comment: "Error Response")
        }
    }
}

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
}

struct Resource<T: Codable> {
    let endpoint: Endpoint
    var method: HTTPMethod = .get([])
    var headers: [String: String]? = nil
    var modelType: T.Type
    
}


struct HTTPClient: HTTPClientProtocol {
    
    private let session: URLSession
    
    
    init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders =  ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        
        var headers: [String: String] = [: ]
        
        // Get the token from keychain
        if let token = Keychain<String>.get("jwttoken") {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        var request = URLRequest(url: resource.endpoint.url)
        
        // Add headers to the request
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set HTTP method and body if needed
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.endpoint.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            request.url = url
            
        case .post(let data), .put(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
            
        case .delete:
            request.httpMethod = resource.method.name
        }
        
        // Set custom headers
        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Check for specific HTTP errors
        switch httpResponse.statusCode {
        case 200...299:
            break // Success
        default:
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NetworkError.errorResponse(errorResponse)
        }
        
        do {
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

struct MockHTTPClient: HTTPClientProtocol {
    
    func load<T>(_ resource: Resource<T>) async throws -> T where T : Decodable, T : Encodable {
        
        try! await Task.sleep(for: .seconds(2.0))
        
        switch resource.endpoint {
        case .categories:
            return PreviewData.load("categories")
        }
    }
}



