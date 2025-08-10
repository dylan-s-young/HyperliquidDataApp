//
//  ASXNService.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation

protocol ASXNFetching {
    func fetchHYPEBuybacks() async throws -> [HypeBuybackModel]
    func fetchHYPEMetrics() async throws -> HypeMetricsModel
}

final class ASXNService: ASXNFetching {
    func fetchHYPEMetrics() async throws -> HypeMetricsModel {
        let endpoint = "https://api-data.asxn.xyz/api/hype-burn/metrics"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(HypeMetricsModel.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.invalidResponse
        }
    }
    
    func fetchHYPEBuybacks() async throws -> [HypeBuybackModel] {
        let endpoint = "https://api-data.asxn.xyz/api/data/hl-buybacks"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode([HypeBuybackModel].self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.invalidResponse
        }
    }
    
}
