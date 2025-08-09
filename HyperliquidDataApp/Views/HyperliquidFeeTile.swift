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
        VStack {
            if hyperliquidViewModel.isLoading {
                ProgressView()
            } else {
                HStack {
                    Text("Fees")
                        .foregroundColor(.white)
                        .bold()
                    
                    Spacer()
                    
                    Text("24h / 1h")
                        .bold()
                        .foregroundColor(.white)
                    
                }
                
                HStack {
                    Text("Burn All Time: \(hyperliquidViewModel.metricData("burnAllTime") ?? 0.0)")
                }
            }
            
        }
        .padding()
//                    .background(Color(hex:"#3054F2"))
        .background(Color(hex: "#6680F5"))
        .cornerRadius(7)
    }
}

#Preview {
    let mockViewModel = HyperliquidViewModel()
    HyperliquidFeeTile()
        .environmentObject(mockViewModel)
}


