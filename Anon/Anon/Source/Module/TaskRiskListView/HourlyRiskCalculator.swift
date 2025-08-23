//
//  HourlyRiskCalculator.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import Foundation
import SwiftData

/// 시간대별 위험도 계산기
class HourlyRiskCalculator {
    
    /// 작업별 시간대별 위험도 계산
    static func calculateHourlyRisk(
        for task: ConstructionTask,
        baseRiskScore: Int
    ) -> [HourlyRiskModel] {
        
        var hourlyRisks: [HourlyRiskModel] = []
        
        // 6시부터 18시까지 시간대별 위험도 계산
        for hour in 6...18 {
            let riskScore = calculateRiskForHour(
                hour: hour,
                task: task,
                baseRiskScore: baseRiskScore
            )
            
            // 기존 HourlyRiskModel 생성 (riskLevel은 computed property로 자동 계산)
            hourlyRisks.append(HourlyRiskModel(hour: hour, score: riskScore))
        }
        
        return hourlyRisks
    }
    
    /// 특정 시간대의 위험도 계산
    private static func calculateRiskForHour(
        hour: Int,
        task: ConstructionTask,
        baseRiskScore: Int
    ) -> Int {
        
        var adjustedRisk = baseRiskScore
        
        // 1. 시간대별 기본 위험도 조정
        adjustedRisk += getTimeBasedRiskAdjustment(hour: hour)
        
        // 2. 작업 유형별 시간대 위험도 조정
        adjustedRisk += getProcessTimeRiskAdjustment(hour: hour, process: task.process)
        
        // 3. 날씨/계절 고려 (현재 시간 기준)
        adjustedRisk += getWeatherSeasonalAdjustment(hour: hour)
        
        // 4. 작업자 수와 시간대 관계
        adjustedRisk += getWorkerTimeAdjustment(hour: hour, workerCount: task.workers)
        
        // 5. 공정 진행률과 시간대 관계
        adjustedRisk += getProgressTimeAdjustment(hour: hour, progress: task.progressRate)
        
        // 위험도 범위 제한 (1-100)
        return max(1, min(100, adjustedRisk))
    }
    
    /// 시간대별 기본 위험도 조정
    private static func getTimeBasedRiskAdjustment(hour: Int) -> Int {
        switch hour {
        case 6...7:   return -5   // 이른 아침: 상대적으로 안전
        case 8...10:  return 0    // 오전: 기본 위험도
        case 11...12: return 5    // 점심 시간대: 피로도 증가
        case 13...14: return 3    // 오후 시작: 점심 후 피로
        case 15...16: return 8    // 오후 후반: 피로도 최고조
        case 17...18: return 2    // 저녁: 작업 마무리
        default:      return 0
        }
    }
    
    /// 작업 유형별 시간대 위험도 조정
    private static func getProcessTimeRiskAdjustment(hour: Int, process: String) -> Int {
        let processType = process.lowercased()
        
        // 고소 작업은 오후에 위험도 증가
        if processType.contains("고소") || processType.contains("height") {
            if hour >= 14 { return 10 }
            if hour >= 12 { return 5 }
        }
        
        // 용접 작업은 오후에 위험도 증가
        if processType.contains("용접") || processType.contains("welding") {
            if hour >= 15 { return 8 }
            if hour >= 13 { return 4 }
        }
        
        // 굴착 작업은 오후에 위험도 증가
        if processType.contains("굴착") || processType.contains("excavation") {
            if hour >= 16 { return 6 }
            if hour >= 14 { return 3 }
        }
        
        return 0
    }
    
    /// 날씨/계절 고려
    private static func getWeatherSeasonalAdjustment(hour: Int) -> Int {
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        // 여름철 (6-8월) 오후 시간대 위험도 증가
        if (6...8).contains(currentMonth) {
            if hour >= 14 { return 5 }
            if hour >= 12 { return 3 }
        }
        
        // 겨울철 (12-2월) 이른 아침/저녁 위험도 증가
        if [12, 1, 2].contains(currentMonth) {
            if hour <= 7 || hour >= 17 { return 4 }
        }
        
        return 0
    }
    
    /// 작업자 수와 시간대 관계
    private static func getWorkerTimeAdjustment(hour: Int, workerCount: Int) -> Int {
        // 작업자 수가 많을수록 오후 시간대 위험도 증가
        if workerCount > 30 {
            if hour >= 15 { return 6 }
            if hour >= 13 { return 3 }
        } else if workerCount > 15 {
            if hour >= 16 { return 4 }
            if hour >= 14 { return 2 }
        }
        
        return 0
    }
    
    /// 공정 진행률과 시간대 관계
    private static func getProgressTimeAdjustment(hour: Int, progress: Int) -> Int {
        // 초기 단계 (0-20%)는 오후에 위험도 증가
        if progress <= 20 {
            if hour >= 15 { return 5 }
            if hour >= 13 { return 2 }
        }
        
        // 마무리 단계 (80-100%)는 오후에 위험도 증가
        if progress >= 80 {
            if hour >= 16 { return 4 }
            if hour >= 14 { return 2 }
        }
        
        return 0
    }
    
    /// 최적 작업 시간 추천
    static func recommendOptimalWorkTime(
        for task: ConstructionTask,
        baseRiskScore: Int
    ) -> (startTime: Int, endTime: Int, reason: String) {
        
        let hourlyRisks = calculateHourlyRisk(for: task, baseRiskScore: baseRiskScore)
        
        // 위험도가 낮은 시간대 찾기
        let lowRiskHours = hourlyRisks.filter { $0.riskLevel == .low }
        
        if let bestHour = lowRiskHours.min(by: { $0.score < $1.score }) {
            let startTime = max(6, bestHour.hour - 1)
            let endTime = min(18, bestHour.hour + 2)
            
            let reason = getRecommendationReason(
                hour: bestHour.hour,
                process: task.process,
                workerCount: task.workers
            )
            
            return (startTime, endTime, reason)
        }
        
        // 낮은 위험도 시간대가 없으면 중간 위험도에서 최적 시간 찾기
        let mediumRiskHours = hourlyRisks.filter { $0.riskLevel == .medium }
        if let bestHour = mediumRiskHours.min(by: { $0.score < $1.score }) {
            let startTime = max(6, bestHour.hour - 1)
            let endTime = min(18, bestHour.hour + 2)
            
            let reason = getRecommendationReason(
                hour: bestHour.hour,
                process: task.process,
                workerCount: task.workers
            )
            
            return (startTime, endTime, reason)
        }
        
        // 기본값
        return (8, 12, "일반적인 안전 시간대")
    }
    
    /// 추천 이유 생성
    private static func getRecommendationReason(hour: Int, process: String, workerCount: Int) -> String {
        var reasons: [String] = []
        
        if hour <= 10 {
            reasons.append("오전 시간대는 피로도가 낮음")
        }
        
        if hour >= 16 {
            reasons.append("오후 후반은 피로도가 높아 위험")
        }
        
        if process.contains("고소") || process.contains("height") {
            reasons.append("고소 작업은 오전에 안전")
        }
        
        if workerCount > 20 {
            reasons.append("작업자 수가 많아 오후 시간대 위험")
        }
        
        return reasons.isEmpty ? "일반적인 안전 시간대" : reasons.joined(separator: ", ")
    }
}
