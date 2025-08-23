//
//  TodayProgressCard.swift
//  Anon
//
//  Created by 김성현 on 2025-08-24.
//

import SwiftUI

struct TodayProgressCard: View {
    let tasks: [ConstructionTask]
    
    var body: some View {
        HStack(spacing: 0) {
            // 왼쪽: 오늘의 작업 위험도 순서
            VStack(alignment: .leading, spacing: 8) {
                Text("Tasks to watch")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(topThreeTasks.indices, id: \.self) { index in
                        if index < topThreeTasks.count {
                            HStack(spacing: 8) {
                                Text("\(index + 1).")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 20, alignment: .leading)
                                
                                Text(topThreeTasks[index].process)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    // 작업이 3개 미만인 경우 빈 공간 채우기
                    ForEach(topThreeTasks.count..<3, id: \.self) { _ in
                        HStack(spacing: 8) {
                            Text("")
                                .font(.subheadline)
                                .frame(width: 20, alignment: .leading)
                            
                            Text("")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1)
                .padding(.vertical, 8)
            
            // 오른쪽: 오늘의 위험도 점수
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Risk Score")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(averageRiskScore)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Computed Properties
    
    /// 위험도 순으로 정렬된 상위 3개 작업
    private var topThreeTasks: [ConstructionTask] {
        let sortedTasks = tasks.sorted { $0.riskScore > $1.riskScore }
        return Array(sortedTasks.prefix(3))
    }
    
    /// 상위 3개 작업의 평균 위험도 (없으면 0)
    private var averageRiskScore: Int {
        guard !topThreeTasks.isEmpty else { return 0 }
        
        let totalScore = topThreeTasks.reduce(0) { $0 + $1.riskScore }
        return totalScore / topThreeTasks.count
    }
}

#Preview {
    TodayProgressCard(tasks: [
        ConstructionTask(
            category: "건축물",
            subcategory: "공동주택",
            process: "Concrete pour",
            progressRate: 30,
            workers: 25,
            startTime: Date(),
            riskScore: 85
        ),
        ConstructionTask(
            category: "건축물",
            subcategory: "공장",
            process: "rebar, tie-in",
            progressRate: 45,
            workers: 15,
            startTime: Date(),
            riskScore: 72
        ),
        ConstructionTask(
            category: "터널",
            subcategory: "철도터널",
            process: "굴착, 조성",
            progressRate: 20,
            workers: 40,
            startTime: Date(),
            riskScore: 68
        )
    ])
    .padding()
    .background(Color.gray.opacity(0.1))
}
