//
//  APIClient.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation

// Define network-related errors
enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case invalidPriceFormat(String)
}

protocol APIClientProtocol {
    func request<T: Decodable>(
        _ endpoint: URL,
        method: String,
    ) async throws -> T
}


final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.dateDecodingStrategy = .iso8601
            return d
         }(),
         encoder: JSONEncoder = {
            let e = JSONEncoder()
            return e
    }(),
     ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
     }
    
    func request<T: Decodable>(
        _ endpoint: URL,
        method: String,
    ) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = method
        
        let (data, response) = try await self.session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try self.decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}
