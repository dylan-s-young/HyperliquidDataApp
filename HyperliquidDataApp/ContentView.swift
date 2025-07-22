//
//  ContentView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CryptoViewModel()

    var body: some View {
        VStack {
            HomeView()
                .environmentObject(viewModel)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
