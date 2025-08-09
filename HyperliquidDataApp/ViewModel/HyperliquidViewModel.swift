//
//  HyperliquidViewModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation
// MARK: - TODO: Refactor Screen

final class HyperliquidViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var hypeMetricData: HypeMetricsModel? = nil
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
    
    
    
    
    
    
    
    
    
}
