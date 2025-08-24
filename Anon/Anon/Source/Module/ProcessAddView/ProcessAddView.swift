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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State private var step: OnboardingStep = .workType
    
    @State private var task: ConstructionTask?
    let taskId: String?
    
    
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

    init(taskId: String?, step: OnboardingStep? = .workType) {
        self.taskId = taskId
        _step = State(initialValue: step ?? .workType)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 36) {
            
            if step != .workType {
                NavigationBar(style: .simpleBack, onBack: { goBack() })
            }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 50) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(step.title)
                            .font(.h3)
                        Text(step.text)
                            .font(.b1)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                    
                    
                    // ── 하단 버튼(이전/다음) ───────────────────────────────
                    
                    NextButton(
                        buttonType: step != .workType && !(taskId?.isEmpty ?? true) ? .save : (step == .addTask ? .start : .next),
                        //삼항 연산자
                        // 기존 아이디가 있으면 저장하기(수정버튼)
                        buttonStyle: canNext ? .enabled : .disabled
                    ) {
                        withAnimation { goNext() }
                    }
                    .safeAreaPadding(.horizontal, 16)
                }
                
                Spacer()
                
                // ── 하단 버튼(이전/다음) ───────────────────────────────
                
                NextButton(
                    buttonType: step == .workProgress && !(taskId?.isEmpty ?? true) ? .save : (step == .addTask ? .start : .next),
                    //삼항 연산자
                    // 프로그레스 스탭에서 기존 아이디가 있으면 저장하기(수정버튼)
                    buttonStyle: canNext ? .enabled : .disabled
                ) {
                    withAnimation { goNext() }
                }
                
            }
            .onAppear {
                guard let idString = taskId,
                      let id = UUID(uuidString: idString),
                      let fetchedTask = container.taskRepository.fetchTask(by: id)
                else { return }
                
                self.task = fetchedTask

                self.selectedProcess = WorkProcess.from(fetchedTask.process)
                self.headcount = fetchedTask.workers
                self.startTime = fetchedTask.startTime
                self.progress = fetchedTask.progressRate
            }
            .safeAreaPadding(.horizontal, 16)
            .safeAreaPadding(.top, step == .workType ? 84 : 0)
            .safeAreaPadding(.bottom, 12)
        }
    }
    
    // MARK: - Navigation
    private func goNext() {
        if let id = taskId, !id.isEmpty {
            guard let id = taskId, !id.isEmpty, let task = task else { return }
            
            var updatedCategory: String? = nil
            var updatedSubcategory: String? = nil
            var updatedProcess: String? = nil
            var updatedProgressRate: Int? = nil
            var updatedWorkers: Int? = nil
            var updatedStartTime: Date? = nil
            
            // 카테고리
            if let large = selectedLargeType, large.largeWork != task.category {
                updatedCategory = large.largeWork
            }
            
            // 소분류
            if let medium = selectedWorkType, medium != task.subcategory {
                updatedSubcategory = medium
            }
            
            // 프로세스
            if let process = selectedProcess, process.title != task.process {
                updatedProcess = process.title
            }
            
            // 인원수
            if let workers = headcount, workers != task.workers {
                updatedWorkers = workers
            }
            
            // 진행률
            if progress != task.progressRate {
                updatedProgressRate = progress
            }
            
            // 시작시간
            if startTime != task.startTime {
                updatedStartTime = startTime
            }
            
            if updatedCategory != nil ||
                updatedSubcategory != nil ||
                updatedProcess != nil ||
                updatedProgressRate != nil ||
                updatedWorkers != nil ||
                updatedStartTime != nil {
                container.taskRepository.updateTask(
                    task,
                    category: updatedCategory ?? task.category,
                    subcategory: updatedSubcategory ?? task.subcategory,
                    process: updatedProcess ?? task.process,
                    workers: updatedWorkers ?? task.workers,
                    startTime: updatedStartTime ?? task.startTime,
                    progressRate: updatedProgressRate ?? task.progressRate
                )
            }
            
            dismiss()
        }
        
        
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
    
    // MARK: - SwiftData 저장
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
            
//            // 테스크 저장 완료 후 메인 화면으로 이동
//            DispatchQueue.main.async {
//                appFlowViewModel.appState = .main
//            }
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
        }
    }
    
    // MARK: - Helper Methods
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
    ProcessAddView(taskId: "")
}
