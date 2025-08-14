//
//  HypeBubackBarChartModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/13/25.
//

import Foundation

struct HypeBuybackBarChartModel: Identifiable {
    let id = UUID()
    let date: Date
    let amountBurned: Double
}
