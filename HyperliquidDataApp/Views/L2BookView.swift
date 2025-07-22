//
//  L2BookView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/21/25.
//

import SwiftUI

struct L2BookView: View {
    @EnvironmentObject var viewModel: CryptoViewModel
    
    var body: some View {
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
    }
}

#Preview {
    L2BookView()
        .environmentObject(CryptoViewModel())
}
