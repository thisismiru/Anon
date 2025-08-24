//
//  Color+.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUICore

extension Color {
    static func riskColor(for score: Int) -> Color {
        switch score {
        case 0..<20:  return .green   // 안전
        case 20..<40: return .yellow  // 주의
        default:      return .red     // 위험
        }
    }
}
