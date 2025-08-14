//
//  ContentView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var hyperliquidViewModel = HyperliquidViewModel()
    @StateObject private var cryptoMidPriceViewModel = CryptoMidPriceViewModel()
    @StateObject private var l2BookViewModel = L2BookViewModel()

    var body: some View {
        // TODO: Refactor to a TabView, favorited positions? Or data?
        
        VStack {
            HomeView()
                .environmentObject(cryptoMidPriceViewModel)
                .environmentObject(hyperliquidViewModel)
                .environmentObject(l2BookViewModel)
        }
    }
}

#Preview {
    ContentView()
}
