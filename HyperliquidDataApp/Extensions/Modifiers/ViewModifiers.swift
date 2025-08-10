//
//  ViewModifiers.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/21/25.
//

import Foundation
import SwiftUI

struct BackgroundButtonModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(7)
    }
}

