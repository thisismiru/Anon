//
//  ConstructionTaskRepository.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation
import SwiftData

/// ConstructionTask 데이터를 관리하는 저장소 (CRUD)
final class ConstructionTaskRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    /// 새로운 작업(Task)을 추가합니다.
    /// - Parameters:
    ///   - category: 공사 종류 (중분류)
    ///   - subcategory: 공사 종류 (소분류)
    ///   - process: 작업 프로세스
    ///   - progressRate: 공정 진행률 (0 ~ 100)
    ///   - workers: 투입 인원 수
    ///   - startTime: 작업 시작 시간
    ///   - riskScore: 위험 점수 (0 ~ 100)
    func addTask(category: String,
                 subcategory: String,
                 process: String,
                 progressRate: Int,
                 workers: Int,
                 startTime: Date,
                 riskScore: Int) {
        let task = ConstructionTask(
            category: category,
            subcategory: subcategory,
            process: process,
            progressRate: progressRate,
            workers: workers,
            startTime: startTime,
            riskScore: riskScore
        )
        context.insert(task)
        try? context.save()
    }
    
    /// 특정 ID로 작업(Task)을 조회합니다.
    /// - Parameter id: 조회할 작업의 고유 ID(UUID)
    /// - Returns: 해당 ID를 가진 `ConstructionTask`, 없으면 `nil`
    func fetchTask(by id: UUID) -> ConstructionTask? {
        let descriptor = FetchDescriptor<ConstructionTask>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }
    
    /// 기존 작업(Task)의 속성을 업데이트합니다.
    /// - Parameters:
    ///   - task: 수정할 `ConstructionTask`
    ///   - progressRate: 변경할 공정 진행률 (옵셔널, 지정하지 않으면 변경 없음)
    ///   - riskScore: 변경할 위험 점수 (옵셔널, 지정하지 않으면 변경 없음)
    func updateTask(_ task: ConstructionTask,
                    progressRate: Int? = nil,
                    riskScore: Int? = nil) {
        if let progressRate = progressRate {
            task.progressRate = progressRate
        }
        if let riskScore = riskScore {
            task.riskScore = riskScore
        }
        try? context.save()
    }
    
    /// 특정 작업(Task)을 삭제합니다.
    /// - Parameter task: 삭제할 `ConstructionTask`
    func deleteTask(_ task: ConstructionTask) {
        context.delete(task)
        try? context.save()
    }
}
