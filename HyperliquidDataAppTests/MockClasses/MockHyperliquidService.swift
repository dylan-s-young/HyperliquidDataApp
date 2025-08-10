//
//  MockHyperliquidService.swift
//  HyperliquidDataAppTests
//
//  Created by Dylan Young on 7/22/25.
//

import Foundation
@testable import HyperliquidDataApp

//enum HyperliquidError: Error, Equatable {
//    case networkError(String)
//    case serverError(String)
//    case invalidData(String)
//}

class MockHyperliquidService: HyperliquidFetching {
    var mockPrices: [String: Double] = ["BTC": 120000,
                                        "ETH": 3040,
                                        "HYPE": 12.50]
    var mockL2BookData = L2BookModel(coin: "ETH",
                                     time: Int(Date().timeIntervalSince1970),
                                     levels: [
                                        [
                                            L2Data(price: "2999.1", size: "1000", n: 3),
                                            L2Data(price: "2999.3", size: "1000", n: 3)
                                        ],
                                        [
                                            L2Data(price: "3000.2", size: "1000", n: 3)
                                        ]
                                     ])
    var shouldThrowInvalidURL: Bool = false
    var shouldThrowInvalidResponse: Bool = false
    var shouldThrowDecodingError: Bool = false
    
    func fetchPrices() async throws -> [String: Double] {
        if shouldThrowInvalidURL {
            throw NetworkError.invalidURL
        }
        return mockPrices
    }
    
    func fetchL2BookData(coin: String, numberOfSignificantFigs: Int?, mantissa: Int?) async throws -> L2BookModel {
        return mockL2BookData
    }
}
