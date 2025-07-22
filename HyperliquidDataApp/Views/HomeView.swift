//
//  HomeView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

import SwiftUI

struct HomeView: View {
    /// Mark: Variables & Constants
    @EnvironmentObject var cryptoMidPriceViewModel: CryptoMidPriceViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                /// L2 Book View
                NavigationLink {
                    L2BookView()
                } label: {
                    Text("L2 Book View")
                        .customButtonBackground(backgroundColor: Color.red)
                }
                
                /// Crypto Mid Price View
                NavigationLink {
                    CryptoMidPriceView()
                } label: {
                    Text("Crypto Mid Prices")
                        .customButtonBackground(backgroundColor: Color.green)
                }
            }
            .navigationTitle("Hyperliquid Data App")
            .padding(.horizontal)
        }
        .onAppear {
            cryptoMidPriceViewModel.startPolling()
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(CryptoMidPriceViewModel())
}
