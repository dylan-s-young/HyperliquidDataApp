//
//  L2BookViewModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/22/25.
//

import Foundation

class L2BookViewModel: ObservableObject {
    @Published var l2Data: L2BookModel?
    @Published var selectedL2Coin: CryptoSelection = .BTC
    @Published var numberOfSignificantFigs: Int? = nil
    @Published var mantissa: Int? = nil

    private let service: HyperliquidService
    private var timer: PollingTimer?

    init(service: HyperliquidService = HyperliquidService()) {
        self.service = service
    }

    func startPolling() {
        timer = PollingTimer(interval: 2) { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchL2BookData(
                    asset: self.selectedL2Coin.rawValue,
                    numberOfSignificantFigs: self.numberOfSignificantFigs,
                    mantissa: self.mantissa
                )
            }
        }
        timer?.start()
    }

    func stopPolling() {
        timer?.stop()
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
            l2Data = l2DataResponse
        } catch {
            print("Error fetching: \(error)")
        }
    }
}
