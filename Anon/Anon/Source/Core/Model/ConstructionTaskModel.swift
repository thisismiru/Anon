//
//  ConstructionTaskModel.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation
import SwiftData

@Model
class ConstructionTask {
    @Attribute(.unique) var id: UUID
    var category: String       // 공사종류 (중분류)
    var subcategory: String    // 공사종류 (소분류)
    var process: String        // 작업 프로세스
    var progressRate: Int      // 공정 진행률 (0 ~ 100)
    var workers: Int           // 투입 인원
    var startTime: Date        // 작업 시작 시각
    var riskScore: Int         // 위험 점수 (0 ~ 100 등급)
    
    init(category: String,
         subcategory: String,
         process: String,
         progressRate: Int,
         workers: Int,
         startTime: Date,
         riskScore: Int) {
        self.id = UUID()
        self.category = category
        self.subcategory = subcategory
        self.process = process
        self.progressRate = progressRate
        self.workers = workers
        self.startTime = startTime
        self.riskScore = riskScore
    }
}

extension ConstructionTask {
    /// process(String)을 WorkProcess enum으로 변환
    var workProcess: WorkProcess {
        return WorkProcess.from(process) ?? .others
    }
}
