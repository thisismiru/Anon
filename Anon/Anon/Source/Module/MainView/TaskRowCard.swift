//
//  TaskRowCard.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct ChecklistItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let desc: String
    var done: Bool
}

struct TaskRowCard: View {
    let task: ConstructionTask
    @Binding var isExpanded: Bool
    
    @State private var checks: [ChecklistItem] = []
    
    init(task: ConstructionTask, isExpanded: Binding<Bool>) {
        self.task = task
        self._isExpanded = isExpanded
        
        // process(String) → WorkProcess 변환 후 체크리스트 불러오기
        let process = task.workProcess
        _checks = State(initialValue: process.checkList.map {
            ChecklistItem(title: $0.title, desc: $0.content, done: false)
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerRow
            
            if isExpanded {
                VStack(spacing: 20) {
                    ForEach($checks) { $item in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.labelM)
                                    .foregroundStyle(.neutral100)
                                    .transition(.opacity.combined(with: .move(edge: .top))) // ✅ 텍스트 먼저 사라짐
                                
                                Text(item.desc)
                                    .font(.b2)
                                    .foregroundStyle(.neutral70)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            Spacer()
                            CustomCheckBox(isChecked: $item.done)
                                .frame(width: 24, height: 24)
                                .transition(.scale.combined(with: .opacity)) // ✅ 체크박스는 축소되며 사라짐
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                // ✅ 부모 VStack에는 opacity 빼고 frame만 애니메이션 → 글자가 먼저 빠진 후 공간 줄어듦
                .animation(.easeInOut(duration: 0.25), value: checks)
            }

        }
    }
    
    // MARK: - Header Row
    private var headerRow: some View {
        HStack(alignment: .center) {
            // 좌측 점 + 텍스트
            HStack(alignment: .top) {
                Circle()
                    .fill(dotColor(for: task.riskScore))
                    .frame(width: 10, height: 10)
                    .padding(.top, 7.5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.process)
                        .font(.h5)
                        .foregroundStyle(.neutral100)
                    
                    Text(MainView.timeFormatter.string(from: task.startTime))
                        .font(.b2)
                        .foregroundStyle(.neutral60)
                }
            }
            
            Spacer()
            
            badgeView
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private var badgeView: some View {
        let numerator = checks.filter { $0.done }.count
        let denominator = checks.count
        
        if denominator > 0, numerator == denominator {
            Text("Done")
                .font(.labelL)
                .foregroundStyle(.blue90)
                .padding(.horizontal, 18)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.blue10))
        } else {
            HStack(spacing: 0) {
                Text("\(numerator)")
                    .font(.pretendard(type: .semiBold, size: 13))
                    .foregroundStyle(.neutral100)
                
                Text("/ \(denominator)")
                    .font(.pretendard(type: .semiBold, size: 13))
                    .foregroundStyle(.neutral50)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(Color.neutral10)
            )
        }
    }
    
    // MARK: - Risk Dot Color
    private func dotColor(for score: Int) -> Color {
        Color.riskColor(for: score)
    }
}
