//
//  L2BookModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/21/25.
//

import Foundation


struct L2BookModel: Decodable {
    let coin: String
    let time: Int
    let levels: [[L2Data]]
}

struct L2Data: Decodable, Identifiable {
    let id = UUID()
    let price: String
    let size: String
    let n: Int
    
    enum CodingKeys: String, CodingKey {
        case price = "px"
        case size = "sz"
        case n
    }
}
