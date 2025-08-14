//
//  Endpoint.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation

enum Endpoint {
    case ASXNMetrics
    case ASXNBuybacks
    
}

private extension Endpoint {
    static func makeForASXNEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api-data.asxn.xyz/api/\(endpoint)")!
    }
    
    static func makeForHyperliquidEndpoint(_ endpoint: String) -> URL{
        URL(string: "https://api.hyperliquid.xyz/info\(endpoint)")!
    }
    
}

extension Endpoint {
    var url: URL {
        switch self {
        case .ASXNMetrics:
            return Endpoint.makeForASXNEndpoint("hype-burn/metrics")
        case .ASXNBuybacks:
            return Endpoint.makeForASXNEndpoint("data/hl-buybacks")
        }
    }
}
