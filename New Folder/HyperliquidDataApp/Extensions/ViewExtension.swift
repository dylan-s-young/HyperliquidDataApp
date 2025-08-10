//
//  ViewExtension.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/21/25.
//

import Foundation
import SwiftUI

extension View {
    func customButtonBackground(backgroundColor: Color) -> some View {
        self.modifier(BackgroundButtonModifier(backgroundColor: backgroundColor))
    }
}
