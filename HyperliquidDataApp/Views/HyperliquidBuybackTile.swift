//
//  HyperliquidFeeTile.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import SwiftUI

struct HyperliquidBuybackTile: View {
    @EnvironmentObject var hyperliquidViewModel: HyperliquidViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if hyperliquidViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                HStack {
                    Text("Fees")
                        .foregroundColor(.white)
                        .bold()

                    Spacer()

                    Text("7D / 24h")
                        .bold()
                        .foregroundColor(.white)
                }

                Text("\(hyperliquidViewModel.buybackData(.Time7D) ?? "0.0")")
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                    .lineLimit(1)

                Text("\(hyperliquidViewModel.buybackData(.Time24h) ?? "0.0")")
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                    .lineLimit(1)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color(hex: "#6680F5"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
    }
}

#Preview {
    let api: APIClientProtocol = APIClient()
    let service: ASXNFetching = ASXNService(api: api)

    let mockViewModel = HyperliquidViewModel(service: service)
    HyperliquidBuybackTile()
        .environmentObject(mockViewModel)
}


