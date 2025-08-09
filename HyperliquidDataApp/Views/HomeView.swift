//
//  HomeView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Variables & Constants
    @EnvironmentObject var hyperliquidViewModel: HyperliquidViewModel
    @EnvironmentObject var cryptoMidPriceViewModel: CryptoMidPriceViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background
                Color(hex: "#0A2342")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading,
                       spacing: 16) {
                    
                    Image(uiImage: UIImage.hlLogoWhite)
                        .resizable()
                        .scaledToFit()
                        
                        
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
                    
                    
                    Text("Websockets")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    NavigationLink {
                        WebSocketView()
                        
                    } label: {
                        Text("Hyperliquid Mid Prices")
                            .customButtonBackground(backgroundColor: Color.orange)
                    }
                    
                    Text("Requests")
                        .font(.title)
                        .foregroundColor(.white)
                    
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
                    
                    Spacer()
                }

                .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                await hyperliquidViewModel.fetchHypeMetricData()
            }
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(CryptoMidPriceViewModel())
}
