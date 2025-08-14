//
//  HyperliquidBuybackDetailedView.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 8/9/25.
//

import SwiftUI
import Charts

struct HyperliquidBuybackDetailedView: View {
    @EnvironmentObject var hyperliquidViewModel: HyperliquidViewModel
    
    var body: some View {
        VStack(alignment: .leading ) {
            Text("HYPE Burn Statistics")
                .font(.title)
                .bold()
            
            Spacer()
            
            Text("Burned Amount - denominated in HYPE")
             
            Chart {
                // TODO: Switch to DI 
                ForEach(hyperliquidViewModel.buildChartData()) { entry in
                    BarMark(
                        x: .value("Date",entry.date, unit: .month),
                        y: .value("Amount", entry.amountBurned)
                    )
                }
            }
            .frame(height: 250)
            .foregroundStyle(Color.blue.gradient)
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let api: APIClientProtocol = APIClient()
    let service: ASXNFetching = ASXNService(api: api)

    let mockViewModel = HyperliquidViewModel(service: service)
    
    HyperliquidBuybackDetailedView()
        .environmentObject(mockViewModel)
}
