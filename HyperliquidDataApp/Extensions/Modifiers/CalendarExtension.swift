//
//  CalendarExtension.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/14/25.
//

import Foundation

extension Calendar {
    /// Returns the first day of the month for a given date.
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}
