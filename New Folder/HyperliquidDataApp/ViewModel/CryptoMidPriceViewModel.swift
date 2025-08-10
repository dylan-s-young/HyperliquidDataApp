//
//  CryptoViewModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//
import SwiftUI
import Foundation

final class CryptoMidPriceViewModel: ObservableObject {
    @Published var prices: [String: Double] = [:]
    @Published var searchText: String = ""
    @Published var l2Data: L2BookModel?
    @Published var selectedL2Coin: CryptoSelection = .BTC
    
    private let service: HyperliquidFetching
    private var timer: PollingTimer?
    private var previousValues: [String: Double] = [:]
    private var blinkingKeys: Set<String> = []
    
    init(service: HyperliquidService = HyperliquidService()) {
        self.service = service
    }
    
    var filterDictionary: [String: Double] {
        if searchText.isEmpty {
            return prices.filter { !$0.key.hasPrefix("@") }
        } else {
            return prices.filter { $0.key.localizedStandardContains(searchText) }
        }
    }
    
    func startPolling() {
        timer = PollingTimer(interval: 5) { [weak self] in
            Task {
                await self?.fetchMidPrice()
            }
        }
        timer?.start()
    }
    
    func stopPolling() {
        timer?.stop()
    }
    
    func colorForKey(_ key: String) -> Color {
        guard let currentValue = filterDictionary[key],
              let previousValue = previousValues[key] else {
            return .primary // Default color if no previous value
        }
        return currentValue > previousValue ? .green : .red
    }
    
    func isBlinking(key: String) -> Bool {
        return blinkingKeys.contains(key)
    }
    
    func triggerBlink() {
        let changedKeys = filterDictionary.keys.filter { key in
            guard let currentValue = filterDictionary[key],
                  let previousValue = previousValues[key] else {
                return false
            }
            return currentValue != previousValue
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            blinkingKeys = Set(changedKeys)
        }

        // Reset blinking after 0.6s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) {
                self?.blinkingKeys.removeAll()
            }
        }
    }
    
    ///
    @MainActor
    private func fetchMidPrice() async {
        do {
            let newPrices = try await service.fetchPrices()
            previousValues = prices // Store current prices before updating
            prices = newPrices
            triggerBlink() // Trigger blink for changed prices
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    @MainActor
    func fetchL2BookData(asset: String = "BTC",
                         numberOfSignificantFigs: Int? = nil,
                         mantissa: Int? = nil) async {
        do {
            let l2DataResponse = try await service.fetchL2BookData(
                coin: asset,
                numberOfSignificantFigs: numberOfSignificantFigs,
                mantissa: mantissa
            )
            print("success")
            l2Data = l2DataResponse
            // handle l2Data (e.g., store it in @Published property)
        } catch {
            print("Error fetching: \(error)")
        }
    }
}
