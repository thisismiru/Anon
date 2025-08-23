//
//  ProcessAddView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI

// 1) 단계
enum OnboardingStep: Int, CaseIterable {
    case workType, workProcess, workProgress, headcount, startTime, addTask
    
    var title: String {
        switch self {
        case .workType:
            return "Choose construction type"
        case .workProcess:
            return "Select today’s work process"
        case .workProgress:
            return "Set the current progress"
        case .headcount:
            return "Enter the number of workers"
        case .startTime:
            return "Select the work start time"
        case .addTask:
            return "Add another task?"
        }
    }
    
    var text: String {
        switch self {
        case .workType:
            return "This will be used for risk & checklist suggestions"
        case .workProcess:
            return "You can add more later"
        case .workProgress:
            return "An estimate is fine—you can update it later"
        case .headcount:
            return "This will be used for the safety briefing"
        case .startTime:
            return "This sets today’s timeline"
        case .addTask:
            return "You can add multiple tasks in a row"
        }
    }
}

// 2) 컨테이너
struct ProcessAddView: View {
    @State private var step: OnboardingStep = .workType

    // 수집 데이터 (필요한 것만 추가/수정)
    @State private var selectedWorkType: String? = nil
    @State private var selectedProcess: String? = nil
    @State private var progress: Double = 0
    @State private var headcount: Int? = nil
    @State private var startTime: Date = .now

    var canNext: Bool {
        switch step {
        case .workType:    return selectedWorkType != nil
        case .workProcess: return selectedProcess != nil
        case .workProgress:return progress > 0
        case .headcount:   return (headcount ?? 0) > 0
        case .startTime:   return true
        case .addTask:     return true
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            
            if step != .workType {
                NavigationBar(style: .simpleBack)
            }

            VStack(spacing: 50) {
                // ── 고정 헤더(변하지 않음) ───────────────────────────────
                VStack(alignment: .leading, spacing: 8) {
                    Text(step.title)
                        .font(.title3.bold())
                    Text(step.text)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // ── 아래 컨텐츠만 단계에 따라 교체 ─────────────────────
                ZStack { // 전환이 자연스럽게
                    // TODO: - 나중에 적용하기
                    //                switch step {
                    //                case .workType:
                    //                    WorkTypeSelectView(selected: $selectedWorkType)
                    //                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    //                case .workProcess:
                    //                    WorkProcessSelectView(selected: $selectedProcess)
                    //                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    //                case .workProgress:
                    //                    WorkProgressInputView(value: $progress)
                    //                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    //                case .headcount:
                    //                    WorkHeadcountInputView(value: Binding(
                    //                        get: { Double(headcount ?? 0) },
                    //                        set: { headcount = Int($0) }))
                    //                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    //                case .startTime:
                    //                    WorkStartTimeInputView(date: $startTime)
                    //                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    //                case .addTask:
                    //                    WorkAddTaskView()
                    //                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    //                }
                }
                .animation(.easeInOut(duration: 0.2), value: step)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
            }

            // ── 하단 버튼(이전/다음) ───────────────────────────────
            HStack(spacing: 12) {
                Button("이전") { withAnimation { goBack() } }
                    .buttonStyle(.bordered)
                    .disabled(step == .workType)

            Button("다음") { withAnimation { goNext() } }
                .frame(maxWidth: .infinity, minHeight: 52)
                .foregroundStyle(canNext ? .white : .gray)
                .background(canNext ? Color.blue : Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(!canNext)
            }
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, step == .workType ? 84 : 0)
    }

    // 네비게이션
    private func goNext() {
        guard let i = OnboardingStep.allCases.firstIndex(of: step),
              i < OnboardingStep.allCases.count - 1 else { return }
        step = OnboardingStep.allCases[i + 1]
    }
    private func goBack() {
        guard let i = OnboardingStep.allCases.firstIndex(of: step), i > 0 else { return }
        step = OnboardingStep.allCases[i - 1]
    }
}

#Preview {
    ProcessAddView()
}
