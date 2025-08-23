//
//  HourlyRiskModel.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import Foundation

/// 위험도 레벨
enum RiskLevel: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    static func fromScore(_ score: Int) -> RiskLevel {
        switch score {
        case 0...30: return .low
        case 31...70: return .medium
        default: return .high
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "yellow"
        case .high: return "red"
        }
    }
}

struct HourlyRiskModel: Identifiable {
    let id = UUID()
    let hour: Int      // 0~23
    let score: Int     // 위험 점수 (0~100)
    
    // 위험도 레벨 계산
    var riskLevel: RiskLevel {
        RiskLevel.fromScore(score)
    }
}
