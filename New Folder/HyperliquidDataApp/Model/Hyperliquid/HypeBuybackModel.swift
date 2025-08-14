//
//  HypeBuybackModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct HypeBuybackModel: Codable {
    let date, sz, ntl, averagePrice: String

    enum CodingKeys: String, CodingKey {
        case date, sz, ntl
        case averagePrice = "average_price"
    }
}

