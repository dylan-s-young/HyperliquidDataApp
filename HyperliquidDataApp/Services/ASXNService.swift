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
    private let api: APIClientProtocol
    init(api: APIClientProtocol) { self.api = api }

    func fetchHYPEMetrics() async throws -> HypeMetricsModel {
        try await api.request(Endpoint.ASXNMetrics.url, method: "GET")
    }

    func fetchHYPEBuybacks() async throws -> [HypeBuybackModel] {
        try await api.request(Endpoint.ASXNBuybacks.url, method: "GET")
    }
}
