//
//  HyperliquidServiceTesting.swift
//  HyperliquidDataAppTests
//
//  Created by Dylan Young on 7/25/25.
//

import Testing
@testable import HyperliquidDataApp

struct HyperliquidServiceTesting {
    
    let mockService = MockHyperliquidService()
    
    @Test func testFetchPricesReturnsCorrectValues() async throws {
        // Act
        let prices = try await mockService.fetchPrices()
        
        // Assert
        #expect(prices["BTC"] == 120000, "BTC price should be 120,000")
        #expect(prices["ETH"] == 3040, "ETH price should be 3,040")
        #expect(prices["HYPE"] == 12.50, "HYPE price should be 12.50")
        #expect(prices.count == 3, "There should be exactly 3 price entries")
    }
    
    @Test func testFetchL2BookDataReturnsCorrectETHData() async throws {
        // Arrange
        let coin = "ETH"
        
        // Act
        let bookData = try await mockService.fetchL2BookData(coin: coin, numberOfSignificantFigs: nil, mantissa: nil)
        
        // Assert
        #expect(bookData.coin == "ETH", "Coin should be ETH")
        #expect(bookData.levels.count == 2, "There should be two levels (bids and asks)")
        
        // Test bids (levels[0])
        #expect(bookData.levels[0].count == 2, "There should be 2 bid entries")
        #expect(bookData.levels[0][0].price == "2999.1", "First bid price should be 2999.1")
        #expect(bookData.levels[0][0].size == "1000", "First bid size should be 1000")
        #expect(bookData.levels[0][0].n == 3, "First bid n should be 3")
        #expect(bookData.levels[0][1].price == "2999.3", "Second bid price should be 2999.3")
        #expect(bookData.levels[0][1].size == "1000", "Second bid size should be 1000")
        #expect(bookData.levels[0][1].n == 3, "Second bid n should be 3")
        
        // Test asks (levels[1])
        #expect(bookData.levels[1].count == 1, "There should be 1 ask entry")
        #expect(bookData.levels[1][0].price == "3000.2", "Ask price should be 3000.2")
        #expect(bookData.levels[1][0].size == "1000", "Ask size should be 1000")
        #expect(bookData.levels[1][0].n == 3, "Ask n should be 3")
    }
    
    @Test func testFetchL2BookDataIgnoresCoinParameter() async throws {
        // Arrange
        let coin = "BTC" // Different coin, but mock returns ETH data
        
        // Act
        let bookData = try await mockService.fetchL2BookData(coin: coin, numberOfSignificantFigs: 2, mantissa: 4)
        
        // Assert
        #expect(bookData.coin == "ETH", "Coin should still be ETH regardless of input")
        #expect(bookData.levels[0].count == 2, "Bids should still have 2 entries")
        #expect(bookData.levels[1].count == 1, "Asks should still have 1 entry")
    }
    
    @Test func testInvalidURl() async throws {
        
        mockService.shouldThrowInvalidURL = true
        
        await #expect(throws: NetworkError.invalidURL) {
            try await mockService.fetchPrices()
        }
        
    }
}

