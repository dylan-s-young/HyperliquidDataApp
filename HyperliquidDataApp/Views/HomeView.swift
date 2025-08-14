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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Image(uiImage: UIImage.hlLogoWhite)
                            .resizable()
                            .scaledToFit()
                        
                        HyperliquidBuybackTile()
                            .onTapGesture {
                                print("Tapped")
                                hyperliquidViewModel.shouldPresentSheet.toggle()
                            }
                        
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
                .refreshable {
                    await hyperliquidViewModel.fetchHypeBuybackData()
                    await hyperliquidViewModel.fetchHypeMetricData()
                    
                }
            }
            
            .onAppear {
                Task {
                    await hyperliquidViewModel.fetchHypeBuybackData()
                    await hyperliquidViewModel.fetchHypeMetricData()
                }
            }
        }
        .sheet(isPresented: $hyperliquidViewModel.shouldPresentSheet) {
            HyperliquidBuybackDetailedView()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(CryptoMidPriceViewModel())
        .environmentObject(HyperliquidViewModel(service: ASXNService(api: APIClient())))
}
