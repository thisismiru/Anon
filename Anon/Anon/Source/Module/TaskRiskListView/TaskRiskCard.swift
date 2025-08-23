//
//  TaskRiskCard.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct TaskRiskCard: View {
    let time: String
    let process: String
    let riskScore: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TaskRiskHeader(time: time, process: process)
            
            Spacer()
            
            TaskRiskScore(riskScore: riskScore)
            CustomProgressBar(value: riskScore)
                .frame(height: 20)
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(.neutral0)
        .cornerRadius(12)
        .frame(height: 200)
    }
}

/// Header (시간 + 프로세스명)
fileprivate struct TaskRiskHeader: View {
    let time: String
    let process: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(time)
                .font(.b2)
                .foregroundStyle(.neutral60)
            
            Text(process)
                .font(.h5)
                .foregroundStyle(.neutral100)
        }
    }
}

/// 점수 표시
fileprivate struct TaskRiskScore: View {
    let riskScore: Int
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            Spacer()
            Text("\(riskScore)")
                .font(.pretendard(type: .medium, size: 48)) // TODO: 맞는 폰트 확인 필요
                .foregroundStyle(.neutral100)
            Text("pts")
                .font(.h4)
                .foregroundStyle(.neutral100)
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        HStack(spacing: 9) {
            TaskRiskCard(time: "8:00 AM", process: "마감, 도장", riskScore: 45)
            TaskRiskCard(time: "10:00 AM", process: "철근, 연결", riskScore: 26)
        }
        HStack(spacing: 9) {
            TaskRiskCard(time: "8:00 AM", process: "마감, 도장", riskScore: 20)
            TaskRiskCard(time: "10:00 AM", process: "철근, 연결", riskScore: 7)
        }
    }
    .padding(16)
    .background(.neutral20)
}
