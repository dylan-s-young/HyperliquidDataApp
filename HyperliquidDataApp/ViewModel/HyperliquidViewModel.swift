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
    @Published var isLoading: Bool = false
    @Published var hypeMetricData: HypeMetricsModel? = nil
    @Published var hypeBuybackData: [HypeBuybackModel] = []
    @Published var errorMessage: String? = nil
    
    private let service: ASXNFetching
    
    // MARK: - Initializer
    init(service: ASXNService = ASXNService()) {
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
    
    // MARK: - Servuce functions
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
