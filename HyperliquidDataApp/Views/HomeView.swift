//
//  HomeView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

import SwiftUI

struct HomeView: View {
    /// Mark: Variables & Constants
    @EnvironmentObject var viewModel: CryptoViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
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
            .padding(.horizontal)
        }
        .navigationTitle("Hyperliquid Data App")
        .onAppear {
            viewModel.startPolling()
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(CryptoViewModel())
}
