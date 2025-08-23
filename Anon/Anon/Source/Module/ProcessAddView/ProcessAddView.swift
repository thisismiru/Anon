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
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State private var step: OnboardingStep = .workType
    
    
    // ✅ SwiftData 컨텍스트
    @Environment(\.modelContext) private var modelContext    
    // ✅ PredictViewModel 추가
    @StateObject private var predictViewModel = PredictViewModel()
    
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
                            AddTaskView(onTapAdd: {        // ⬅️ 콜백 연결
                                withAnimation {
                                    restart()
                                }
                            })
                        }
                        
                    }
                    
                    Spacer()
                    
                    NextButton(
                        buttonType: step == .addTask ? .start : .next,  // 마지막 단계면 "Start"로
                        buttonStyle: canNext ? .enabled : .disabled
                    ) {
                        withAnimation { goNext() }
                    }
                    .safeAreaPadding(.horizontal, 16)
                }
                Spacer()
                NextButton(
                    buttonType: step == .addTask ? .start : .next,  // 마지막 단계면 "Start"로
                    buttonStyle: canNext ? .enabled : .disabled
                ) {
                    withAnimation { goNext() }
                }
                .safeAreaPadding(.horizontal, 16)
            }
            .safeAreaPadding(.top, step == .workType ? 84 : 0)
            .safeAreaPadding(.bottom, 12)
        }
    }
    
    // 네비게이션
    private func goNext() {
        // ✅ startTime 단계에서 저장 후 다음 단계로 이동
        if step == .startTime {
            saveCurrentEntry()
        }
        
        if step == .addTask {
            appFlowViewModel.checkInitialState()
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
        
        // ✅ PredictViewModel을 사용하여 위험도 예측 수행
        predictRiskForTask(
            large: large,
            medium: medium,
            process: process,
            workers: workers
        )
    }
    
    // ✅ 위험도 예측 및 작업 저장
    private func predictRiskForTask(
        large: WorkType,
        medium: String,
        process: WorkProcess,
        workers: Int
    ) {
        // PredictViewModel의 입력값 설정
        predictViewModel.selectedWorkType = large
        predictViewModel.selectedMediumWork = medium
        predictViewModel.selectedProcess = convertWorkProcessToProcessType(process)
        predictViewModel.progressRate = Double(progress)
        predictViewModel.selectedWorkerCount = Int64(workers)
        
        // 현재 시간 기준으로 기본 날씨 설정
        let currentHour = Calendar.current.component(.hour, from: Date())
        let defaultWeather: WeatherType
        if currentHour >= 6 && currentHour < 18 {
            defaultWeather = .clear  // 낮: 맑음
        } else {
            defaultWeather = .cloud  // 밤: 흐림
        }
        predictViewModel.selectedWeather = defaultWeather
        
        // 기본 온도/습도 설정
        predictViewModel.temperature = 25.0
        predictViewModel.humidity = 60.0
        
        print("🔍 === 위험도 예측 시작 ===")
        print("  - WorkType: \(large.largeWork)")
        print("  - Medium: \(medium)")
        print("  - Process: \(process.title)")
        print("  - Workers: \(workers)")
        print("  - Progress: \(progress)")
        print("  - Weather: \(defaultWeather)")
        print("=========================")
        
        // 위험도 예측 수행
        predictViewModel.predictRisk()
        
        // 예측 완료 후 작업 저장
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.saveTaskWithPredictedRisk(
                large: large,
                medium: medium,
                process: process,
                workers: workers
            )
        }
    }
    
    // ✅ 예측된 위험도로 작업 저장
    private func saveTaskWithPredictedRisk(
        large: WorkType,
        medium: String,
        process: WorkProcess,
        workers: Int
    ) {
        let predictedRiskScore = Int(predictViewModel.prediction)
        

        let task = ConstructionTask(
            category: large.largeWork,            // 대분류 이름 (String)
            subcategory: medium,                  // 소분류 (String)
            process: process.title,               // 작업 프로세스 (String)
            progressRate: progress,               // 0~100
            workers: workers,                     // 투입 인원
            startTime: startTime,                 // Date
            riskScore: predictedRiskScore         // ✅ 예측된 위험도 사용
        )
        
        modelContext.insert(task)
        
        // 필요하다면 즉시 저장 (기본적으로 자동저장됨)
        do {
            try modelContext.save()
            print("✅ 작업 저장 성공! 위험도: \(predictedRiskScore)점")
            print("📅 시작 시간: \(startTime)")
        } catch {
            print("❌ Save error: \(error)")
        }
    }
    
    // ✅ WorkProcess를 ProcessType으로 변환
    private func convertWorkProcessToProcessType(_ process: WorkProcess) -> ProcessType {
        switch process {
        case .height: return .highAltitude
        case .structure: return .structure
        case .excavation: return .excavation
        case .finishing: return .finishing
        case .electrical: return .electrical
        case .welding: return .welding
        case .transport: return .transport
        case .housekeeping: return .cleanup
        case .cutting: return .cutting
        case .rebar: return .rebar
        case .concrete: return .concrete
        case .demolition: return .demolition
        case .others: return .other
        //         필요하다면 즉시 저장 (기본적으로 자동저장됨)
        do {
            try modelContext.save()
            print("성공했습니다.")
            print(startTime)
        } catch {
            print("Save error: \(error)")
        }
    }
    
    private func restart() {
        // 필요한 수집값 초기화
        selectedLargeType = nil
        selectedWorkType  = nil
        selectedProcess   = nil
        progress          = 0
        headcount         = nil
        startTime         = .now
        
        step = .workType                 // ⬅️ 여기서 단계 리셋
    }
}

#Preview {
    ProcessAddView()
}
