//
//  L2BookView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/21/25.
//

import SwiftUI

// Parking here for now
enum CryptoSelection: String, CaseIterable, Hashable, Identifiable {
    case BTC, ETH, SOL, HYPE

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .BTC: return "Bitcoin"
        case .ETH: return "Ethereum"
        case .SOL: return "Solana"
        case .HYPE: return "Hyperliquid"
        }
    }

    var coinCode: String {
        rawValue
    }
}


struct L2BookView: View {
    @EnvironmentObject var viewModel: CryptoViewModel
    
    var body: some View {
        VStack {
            Picker("Select Coin", selection: $viewModel.selectedL2Coin) {
                ForEach(CryptoSelection.allCases) { coin in
                    Text(coin.displayName).tag(coin)
                }
            }
            .pickerStyle(.menu)
            ScrollView {
                if let l2Data = viewModel.l2Data {
                    VStack(alignment: .center) {
                        Text("📊 \(l2Data.coin) Order Book")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 10)
                        
                        ForEach(l2Data.levels.indices, id: \.self) { sideIndex in
                            let side = l2Data.levels[sideIndex]
                            Text(sideIndex == 0 ? "🟩 Bids" : "🟥 Asks")
                                .font(.headline)
                                .padding(.vertical, 4)
                            
                            ForEach(side) { level in
                                HStack {
                                    Text("Price: \(level.price)")
                                    Spacer()
                                    Text("Size: \(level.size)")
                                    Spacer()
                                    Text("n: \(level.n)")
                                }
                                .font(.subheadline)
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .task {
                await viewModel.fetchL2BookData()
            }
            .onChange(of: viewModel.selectedL2Coin) { _, newValue in
                Task {
                    await viewModel.fetchL2BookData(asset: newValue.coinCode)
                }
            }
        }
        
    }
}

#Preview {
    L2BookView()
        .environmentObject(CryptoViewModel())
}
