//
//  HourlyRiskModel.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import Foundation

struct HourlyRiskModel: Identifiable {
    let id = UUID()
    let hour: Int      // 0~23
    let score: Int     // 위험 점수 (0~100)
}
