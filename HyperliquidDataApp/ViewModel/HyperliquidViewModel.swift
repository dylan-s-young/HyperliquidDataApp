//
//  HyperliquidViewModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation
// MARK: - TODO: Refactor Screen

enum HypeBuybackTimeInterval{
    case Time24h
    case Time7D
}

@MainActor
final class HyperliquidViewModel: ObservableObject {
    @Published var shouldPresentSheet: Bool = false 
    @Published var isLoading: Bool = false
    @Published var hypeMetricData: HypeMetricsModel? = nil
    @Published var hypeBuybackData: [HypeBuybackModel] = []
    @Published var errorMessage: String? = nil
    
    private let service: ASXNFetching
    
    // MARK: - Initializer
    init(service: ASXNFetching) {
        self.service = service
    }
    
    // MARK: - Computed Properties
    var metricData: (_ key: String) -> Double? {
        return { key in
            self.hypeMetricData?.metrics[key] ?? 0.0
        }
    }
    
    var buybackData: (_ timeInterval: HypeBuybackTimeInterval) -> String? {
        return { timeInterval in
            switch timeInterval {
            case .Time24h:
                let sz = Double(self.hypeBuybackData.last?.sz ?? "0.0")?.toAbbreviatedString()
                let notionalValue = Double(self.hypeBuybackData.last?.ntl ?? "0.0")?.toAbbreviatedString()
                
                return "\(sz ?? "0.0") HYPE - $\(notionalValue ?? "0.0") USD"
            
            case .Time7D:
                let totalSz = self.hypeBuybackData
                    .suffix(7)
                    .compactMap { Double($0.sz) }
                    .reduce(0, +)
                    .toAbbreviatedString()
                
                let notionalValue = self.hypeBuybackData
                    .suffix(7)
                    .compactMap { Double($0.ntl) }
                    .reduce(0, +)
                    .toAbbreviatedString()
                
                return "\(totalSz) HYPE - $\(notionalValue) USD"
            }
        }
    }
    
    // MARK: - Helper function
    /// Builds chart data by grouping buyback amounts by month, returning models with Date objects sorted chronologically.
    func buildChartData() -> [HypeBuybackBarChartModel] {
        let parser = ISO8601DateFormatter()
        parser.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var calendar = Calendar.current
        calendar.timeZone = .init(secondsFromGMT: 0) ?? .current
        
        // Group buyback amounts by month-year, using the first day of the month as the Date
        let groupedData = hypeBuybackData.reduce(into: [Date: Double]()) { result, data in
            guard let date = parser.date(from: data.date),
                  let amount = Double(data.sz) else {
                print("Skipping invalid data: date=\(data.date), sz=\(data.sz)")
                return
            }
            // Get the start of the month for grouping
            let startOfMonth = calendar.startOfMonth(for: date)
            result[startOfMonth, default: 0.0] += amount
        }
        
        // Transform to chart models and sort by date
        return groupedData.map { HypeBuybackBarChartModel(date: $0.key, amountBurned: $0.value) }
            .sorted { $0.date < $1.date }
    }

    
    // MARK: - Service functions
    func fetchHypeMetricData() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let fetchResult = try await service.fetchHYPEMetrics()
            hypeMetricData = fetchResult
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchHypeBuybackData() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let fetchResult = try await service.fetchHYPEBuybacks()
            hypeBuybackData = fetchResult
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
