//
//  CustomProgressBar.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct CustomProgressBar: View {
    private let value: Int
    private let maxValue: Int
    
    private var barColor: Color {
        Color.riskColor(for: value)
    }
    
    /// CustomProgressBar
    /// - Parameters:
    ///   - value: 현재 값 (게이지로 표시될 실제 수치)
    ///   - maxValue: 최대 값 (기본값: 50, 게이지 비율 계산에 사용)
    init(value: Int, maxValue: Int = 50) {
        self.value = value
        self.maxValue = maxValue
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.neutral20)
                    .frame(height: geo.size.height)
                
                Capsule()
                    .fill(barColor)
                    .frame(
                        width: min(CGFloat(value) / CGFloat(maxValue) * geo.size.width,
                                   geo.size.width),
                        height: geo.size.height
                    )
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomProgressBar(value: 45, maxValue: 50)
            .frame(height: 20)
        CustomProgressBar(value: 26, maxValue: 50)
            .frame(height: 20)
        CustomProgressBar(value: 7, maxValue: 50)
            .frame(height: 20)
    }
    .padding()
}
