//
//  WebSocketView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/24/25.
//

import SwiftUI

struct WebSocketView: View {
    @StateObject private var viewModel = WebSocketViewModel()
    @State private var currentColor: Color = .black
    @State private var previousPrice: Double? = nil
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.prices.filter({!$0.key.contains("@")}).sorted(by: {$0.key < $1.key}), id: \.key) { pair, price in
                        PriceRowView(pair: pair, price: price)
                            .padding(.vertical, 4)
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
struct PriceRowView: View {
    // Mark: Constants
    let pair: String
    let price: String

    @State private var previousPrice: Double? = nil
    @State private var currentColor: Color = .black
    @State private var colorResetTask: Task<Void, Never>? = nil // To manage the delayed reset

    
    var body: some View {
        HStack {
            Text(pair)
                .bold()
            Spacer()
            Text(price)
                .foregroundColor(currentColor)
        }
        .onChange(of: price) { newPriceString in
            guard let newPrice = Double(newPriceString) else { return }

            var newDisplayColor: Color
            if let prevPrice = previousPrice {
                if newPrice > prevPrice {
                    newDisplayColor = .green // Price increased
                } else if newPrice < prevPrice {
                    newDisplayColor = .red // Price decreased
                } else {
                    newDisplayColor = .black // No change, or back to default
                }
                
                withAnimation(.easeInOut(duration:0.1)) {
                    currentColor = newDisplayColor
                }
            } else {
                currentColor = .black
            }
            colorResetTask = Task {
                do {
                    try await Task.sleep(nanoseconds: 700_000_000) // 0.7 seconds delay
                    // Only reset if the color is still the highlighted one
                    if currentColor == .green || currentColor == .red {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            currentColor = .black // Reset to black
                        }
                    }
                } catch {
                    // Task was cancelled (e.g., new price update arrived before reset)
                    print("Color reset task cancelled for \(pair)")
                }
            }
            
            // Update previousPrice for the next comparison
            previousPrice = newPrice
        }
        .onAppear {
            if let initialPrice = Double(price) {
                previousPrice = initialPrice
            }
        }
    }
}
