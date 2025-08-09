//
//  HypeMetricsModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation

// MARK: - HypeMetricsModel
struct HypeMetricsModel: Codable {
    let metrics: [String: Double]
    let hypeSupplyDistribution: HYPESupplyDistribution
    let dailyBurned, cumulativeDailyBurned: [String: Double]
    let hypeVol: HypeVol

    enum CodingKeys: String, CodingKey {
        case metrics
        case hypeSupplyDistribution = "HYPESupplyDistribution"
        case dailyBurned = "daily_burned"
        case cumulativeDailyBurned = "cumulative_daily_burned"
        case hypeVol = "hype_vol"
    }
}

// MARK: - HYPESupplyDistribution
struct HYPESupplyDistribution: Codable {
    let circulatingSupply, nonCirculatingSupply, totalBurn: CirculatingSupply
}

// MARK: - CirculatingSupply
struct CirculatingSupply: Codable {
    let value: Double
    let percentage: String
}

// MARK: - HypeVol
struct HypeVol: Codable {
    let the24HVol, the7DAvgVol, the30DAvgVol: Double
    let dailyHypeVol: [String: Double]

    enum CodingKeys: String, CodingKey {
        case the24HVol = "24h_vol"
        case the7DAvgVol = "7d_avg_vol"
        case the30DAvgVol = "30d_avg_vol"
        case dailyHypeVol = "daily_hype_vol"
    }
}
