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
        case 0..<20:  return .success   // 안전
        case 20..<40: return .warning  // 주의
        default:      return .error     // 위험
        }
    }
}
