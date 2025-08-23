//
//  ColorExtension.swift
//  Anon
//
//  Created by 김성현 on 2025-08-24.
//

// Color+Hex.swift
import SwiftUI

extension Color {
    /// "#RRGGBB", "#RRGGBBAA", "RRGGBB", "0xRRGGBB", "#RGB", "#RGBA" 지원
    /// `alpha`를 주면 문자열의 알파보다 우선합니다.
    init(hex: String, alpha: Double? = nil) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }
        if s.hasPrefix("0X") { s.removeFirst(2) }

        var value: UInt64 = 0
        Scanner(string: s).scanHexInt64(&value)

        let r, g, b, a: Double
        switch s.count {
        case 3: // RGB (4bit씩)
            r = Double((value & 0xF00) >> 8) / 15.0
            g = Double((value & 0x0F0) >> 4) / 15.0
            b = Double(value & 0x00F) / 15.0
            a = alpha ?? 1.0

        case 4: // RGBA (4bit씩)
            r = Double((value & 0xF000) >> 12) / 15.0
            g = Double((value & 0x0F00) >> 8) / 15.0
            b = Double((value & 0x00F0) >> 4) / 15.0
            let aa = Double(value & 0x000F) / 15.0
            a = alpha ?? aa

        case 6: // RRGGBB
            r = Double((value & 0xFF0000) >> 16) / 255.0
            g = Double((value & 0x00FF00) >> 8) / 255.0
            b = Double(value & 0x0000FF) / 255.0
            a = alpha ?? 1.0

        case 8: // RRGGBBAA  (CSS 스타일)
            r = Double((value & 0xFF000000) >> 24) / 255.0
            g = Double((value & 0x00FF0000) >> 16) / 255.0
            b = Double((value & 0x0000FF00) >> 8) / 255.0
            let aa = Double(value & 0x000000FF) / 255.0
            a = alpha ?? aa

        default:
            // 형식이 이상하면 눈에 띄게 마젠타로
            self = Color(.sRGB, red: 1, green: 0, blue: 1, opacity: 1)
            return
        }

        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    /// 정수 기반 (예: 0x1C64F2)
    init(hex rgb: UInt32, alpha: Double = 1.0) {
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }

    /// AARRGGBB가 필요한 경우(디자인 자산이 ARGB로 올 때)
    init(argb: UInt32) {
        let a = Double((argb & 0xFF000000) >> 24) / 255.0
        let r = Double((argb & 0x00FF0000) >> 16) / 255.0
        let g = Double((argb & 0x0000FF00) >> 8) / 255.0
        let b = Double(argb & 0x000000FF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
