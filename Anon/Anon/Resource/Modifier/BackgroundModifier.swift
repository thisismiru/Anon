//
//  BackgroundModifier.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation
import SwiftUI

/// 백그라운드 modifier
struct backgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .ignoresSafeArea()
            .background(.back)
            
    }
}

extension View {
    func ViewBG() -> some View {
        self.modifier(backgroundModifier())
    }
}
