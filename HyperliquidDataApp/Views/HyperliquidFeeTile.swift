//
//  HyperliquidFeeTile.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import SwiftUI

struct HyperliquidFeeTile: View {
    @EnvironmentObject var hyperliquidViewModel: HyperliquidViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if hyperliquidViewModel.isLoading {
//                ProgressView()
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
        .background(hyperliquidViewModel.isLoading ? nil : Color(hex: "#6680F5"))
        .cornerRadius(7)
    }
}

#Preview {
    let mockViewModel = HyperliquidViewModel()
    HyperliquidFeeTile()
        .environmentObject(mockViewModel)
}


