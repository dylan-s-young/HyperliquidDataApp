//
//  L2BookPostData.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

struct L2BookPostData: Encodable {
    let type: String
    let coin: String?
    let nSigsFigs: Int?
    let mantissa: Int?

    enum CodingKeys: String, CodingKey {
        case type, coin, nSigsFigs, mantissa
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(coin, forKey: .coin)
        try container.encodeIfPresent(nSigsFigs, forKey: .nSigsFigs)
        try container.encodeIfPresent(mantissa, forKey: .mantissa)
    }
}
