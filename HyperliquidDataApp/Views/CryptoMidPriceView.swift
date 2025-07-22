//
//  CryptoMidPriceView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/21/25.
//

import SwiftUI

struct CryptoMidPriceView: View {
    @EnvironmentObject var viewModel: CryptoViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.filterDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text(key)
                                
                            Spacer()
                            Text("$ \(value, specifier: "%.3f")")
                                .bold()
                                .foregroundColor(viewModel.colorForKey(key))
                                .animation(.easeInOut(duration: 1.0), value: viewModel.isBlinking(key: key))
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Look for specific asset")
            .navigationTitle("Mid Prices")
        }
    }
}

#Preview {
    CryptoMidPriceView()
}
