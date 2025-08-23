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
    @EnvironmentObject var container: DIContainer
    @State private var step: OnboardingStep = .workType
    
    private var taskId: String
    @State private var task: ConstructionTask?
    
    // ✅ SwiftData 컨텍스트
        @Environment(\.modelContext) private var modelContext
    
    // 수집 데이터 (필요한 것만 추가/수정)
    @State private var selectedLargeType: WorkType? = nil   // ⬅️ 대분류
    @State private var selectedWorkType: String? = nil      // ⬅️ 소분류
    @State private var selectedProcess: WorkProcess? = nil
    @State private var progress: Int = 0
    @State private var headcount: Int? = nil
    @State private var startTime: Date = .now
    
    var canNext: Bool {
        switch step {
        case .workType:    return selectedWorkType != nil
        case .workProcess: return selectedProcess != nil
        case .workProgress:return progress >= 0
        case .headcount:   return (headcount ?? 0) > 0
        case .startTime:   return true
        case .addTask:     return true
        }
    }
    
    init(taskId: String? = nil) {
        self.taskId = taskId ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            
            if step != .workType {
                NavigationBar(style: .simpleBack, onBack: { goBack() })
            }
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 50) {
                    // ── 고정 헤더(변하지 않음) ───────────────────────────────
                    VStack(alignment: .leading, spacing: 8) {
                        Text(step.title)
                            .font(.title3.bold())
                        Text(step.text)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .safeAreaPadding(.horizontal, 16)
                    
                    // ── 아래 컨텐츠만 단계에 따라 교체 ─────────────────────
                    ZStack {
                        switch step {
                        case .workType:
                            WorkTypeView(
                                selectedLargeType: $selectedLargeType,
                                selectedWorkType: $selectedWorkType
                            )
                        case .workProcess:
                            WorkProcessView(selectedProcess: $selectedProcess)
                        case .workProgress:
                            // WorkProgressInputView …
                            WorkProgressView(progress: $progress)
                        case .headcount:
                            // WorkHeadcountInputView …
                            HeadCountView(headcount: $headcount)
                        case .startTime:
                            // WorkStartTimeInputView …
                            StartTimeView(startTime: $startTime)
                        case .addTask:
                            // WorkAddTaskView …
                            AddTaskView()
                        }
                    }
                    
                }
                
                Spacer()
                
                // ── 하단 버튼(이전/다음) ───────────────────────────────
                NextButton(
                    buttonType: step == .addTask ? .start : .next,  // 마지막 단계면 "Start"로
                    buttonStyle: canNext ? .enabled : .disabled
                ) {
                    withAnimation { goNext() }
                }
                .safeAreaPadding(.horizontal, 16)
            }
        }


        .safeAreaPadding(.top, step == .workType ? 84 : 0)
        .safeAreaPadding(.bottom, 12)
    }
    
    // 네비게이션
    private func goNext() {
        // ✅ startTime 단계에서 저장 후 다음 단계로 이동
        if step == .startTime {
            saveCurrentEntry()
        }
        
        if step == .addTask {
            container.navigationRouter.popToRooteView()
            container.navigationRouter.push(to: .mainView)
        }
        
        guard let i = OnboardingStep.allCases.firstIndex(of: step),
              i < OnboardingStep.allCases.count - 1 else { return }
        step = OnboardingStep.allCases[i + 1]
    }
    private func goBack() {
        guard let i = OnboardingStep.allCases.firstIndex(of: step), i > 0 else { return }
        step = OnboardingStep.allCases[i - 1]
    }
    
    // SwiftData 저장
    private func saveCurrentEntry() {
        guard
            let large = selectedLargeType,         // WorkType
            let medium = selectedWorkType,         // String
            let process = selectedProcess,         // WorkProcess
            let workers = headcount                // Int
        else { return }

        let task = ConstructionTask(
            category: large.largeWork,            // 대분류 이름 (String)
            subcategory: medium,                  // 소분류 (String)
            process: process.title,               // 작업 프로세스 (String)
            progressRate: progress,               // 0~100
            workers: workers,                     // 투입 인원
            startTime: startTime,                 // Date
            riskScore: 88                         // 고정값
        )

        modelContext.insert(task)

//         필요하다면 즉시 저장 (기본적으로 자동저장됨)
         do {
             try modelContext.save()
             print("성공했습니다.")
             print(startTime)
         } catch {
             print("Save error: \(error)")
         }
    }
}

#Preview {
    ProcessAddView()
}
