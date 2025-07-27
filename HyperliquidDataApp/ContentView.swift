//
//  ContentView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cryptoMidPriceViewModel = CryptoMidPriceViewModel()
    @StateObject private var l2BookViewModel = L2BookViewModel()

    var body: some View {
        VStack {
            HomeView()
                .environmentObject(cryptoMidPriceViewModel)
                .environmentObject(l2BookViewModel)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
