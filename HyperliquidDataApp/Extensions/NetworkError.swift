//
//  NetworkError.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

// Define network-related errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case invalidPriceFormat(String)
}
