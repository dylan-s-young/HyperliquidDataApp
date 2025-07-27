//
//  WebSocketView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/24/25.
//

import SwiftUI

struct WebSocketView: View {
    @StateObject private var viewModel = WebSocketViewModel()
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    ForEach(viewModel.prices.sorted(by: {$0.key < $1.key}), id: \.key) { pair, price in
                        HStack {
                            Text(pair)
                            Spacer()
                            Text(price)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.startSubscription()
        }
        .onDisappear {
            viewModel.stopSubscription()
        }
    }
}
