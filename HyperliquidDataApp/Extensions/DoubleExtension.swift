//
//  DoubleExtension.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import Foundation

extension Double {
    func toAbbreviatedString() -> String {
        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch absValue {
        case 1_000_000_000...:
            return "\(sign)\((absValue / 1_000_000_000).toTwoDecimalString())B"
        case 1_000_000...:
            return "\(sign)\((absValue / 1_000_000).toTwoDecimalString())M"
        case 1_000...:
            return "\(sign)\((absValue / 1_000).toTwoDecimalString())K"
        default:
            return "\(sign)\(absValue.toTwoDecimalString())"
        }
    }
    
    func toTwoDecimalString() -> String {
        String(format: "%.2f", self)
    }
}
