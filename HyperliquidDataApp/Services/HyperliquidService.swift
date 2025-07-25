//
//  HyperliquidService.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//
 
import Foundation

// Define typealias for raw API response
typealias RawCryptoPrices = [String: String]

// Define typealias for processed prices
typealias CryptoPrices = [String: Double]

// Struct for API request payload
struct FetchPricePostData: Encodable {
    let type: String
}

struct L2BookPostData: Encodable {
    let type: String
    let coin: String?
    let nSigsFigs: Int?
    let mantissa: Int?

    enum CodingKeys: String, CodingKey {
        case type, coin, nSigsFigs, mantissa
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(coin, forKey: .coin)
        try container.encodeIfPresent(nSigsFigs, forKey: .nSigsFigs)
        try container.encodeIfPresent(mantissa, forKey: .mantissa)
    }
}

// Protocol for fetching crypto prices
protocol HyperliquidFetching {
    func fetchPrices() async throws -> CryptoPrices
    func fetchL2BookData(coin: String, numberOfSignificantFigs: Int?, mantissa: Int? ) async throws -> L2BookModel
}

// Service class to fetch prices from Hyperliquid API
final class HyperliquidService: HyperliquidFetching {
    func fetchL2BookData(coin: String,
                         numberOfSignificantFigs: Int?,
                         mantissa: Int? ) async throws -> L2BookModel {
        let endpoint = "https://api.hyperliquid.xyz/info"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postData = L2BookPostData(type: "l2Book", coin: coin, nSigsFigs: numberOfSignificantFigs, mantissa: mantissa)
        
        do {
            request.httpBody = try JSONEncoder().encode(postData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(L2BookModel.self, from: data)
            
        } catch {
            throw NetworkError.decodingError("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchPrices() async throws -> CryptoPrices {
        let endpoint = "https://api.hyperliquid.xyz/info"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postData = FetchPricePostData(type: "allMids")
        
        do {
            request.httpBody = try JSONEncoder().encode(postData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Verify HTTP status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            // Decode response as [String: String]
            let rawPrices = try JSONDecoder().decode(RawCryptoPrices.self, from: data)
            
            // Convert string prices to Double
            var prices: CryptoPrices = [:]
            for (asset, priceString) in rawPrices {
                guard let price = Double(priceString) else {
                    throw NetworkError.invalidPriceFormat("Invalid price format for \(asset): \(priceString)")
                }
                prices[asset] = price
            }
            
            return prices
        } catch DecodingError.dataCorrupted(_) {
            throw NetworkError.decodingError("Failed to decode API response")
        } catch {
            throw NetworkError.decodingError("Unexpected error: \(error.localizedDescription)")
        }
    }
}



/// histroical data f
