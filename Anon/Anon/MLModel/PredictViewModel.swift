//
//  PredictViewModel.swift
//  Anon
//
//  Created by 김재윤 on 8/24/25.
//

import Foundation
import CoreML
import SwiftData

@MainActor
class PredictViewModel: ObservableObject {
    @Published var accidentTime = Date()
    @Published var selectedWeather: WeatherType = .clear
    @Published var temperature: Double = 25.0
    @Published var humidity: Double = 60.0
    @Published var selectedWorkType: WorkType = .building
    @Published var selectedMediumWork: String = "공동주택"
    @Published var selectedProcess: ProcessType = .structure
    @Published var progressRate: Double = 30.0
    @Published var selectedWorkerCount: Int64 = 19
    
    @Published var prediction: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // SwiftData 관련
    @Published var tasks: [ConstructionTask] = []
    @Published var selectedTask: ConstructionTask?
    
    private var model: ANON?
    
    init() {
        loadModel()
    }
    
    // MARK: - Model Loading
    private func loadModel() {
        do {
            model = try ANON(configuration: MLModelConfiguration())
            print("✅ ANON 모델 로드 성공")
        } catch {
            print("❌ ANON 모델 로드 실패: \(error)")
            errorMessage = "모델 로드 실패: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Task Management
    func loadTasks(from context: ModelContext) {
        let repository = ConstructionTaskRepository(context: context)
        tasks = repository.fetchAllTasks()
        print("📋 작업 목록 로드 완료: \(tasks.count)개")
    }
    
    func selectTask(_ task: ConstructionTask) {
        selectedTask = task
        
        // 선택된 작업의 정보로 UI 업데이트
        accidentTime = task.startTime
        progressRate = Double(task.progressRate)
        
        // category와 subcategory를 기반으로 WorkType과 mediumWork 설정
        updateWorkTypeFromTask(task)
        
        // process를 기반으로 ProcessType 설정
        updateProcessTypeFromTask(task)
        
        // workers를 기반으로 작업자 수 설정
        updateWorkerCountFromTask(task)
        
        print("✅ 작업 선택됨: \(task.category)/\(task.subcategory) - \(task.process)")
    }
    
    private func updateWorkTypeFromTask(_ task: ConstructionTask) {
        // category를 기반으로 WorkType 찾기
        for workType in WorkType.allCases {
            if workType.largeWork == task.category {
                selectedWorkType = workType
                break
            }
        }
        
        // subcategory를 mediumWork로 설정
        selectedMediumWork = task.subcategory
    }
    
    private func updateProcessTypeFromTask(_ task: ConstructionTask) {
        // process를 기반으로 ProcessType 찾기
        for processType in ProcessType.allCases {
            if processType.rawValue == task.process {
                selectedProcess = processType
                break
            }
        }
    }
    
    private func updateWorkerCountFromTask(_ task: ConstructionTask) {
        // workers 수를 직접 설정
        selectedWorkerCount = Int64(task.workers)
    }
    
    func savePredictionAsTask(to context: ModelContext) {
        guard prediction > 0 else {
            errorMessage = "예측 결과가 없습니다."
            return
        }
        
        let repository = ConstructionTaskRepository(context: context)
        
        // 현재 선택된 값들로 새 작업 생성
        let newTask = ConstructionTask(
            category: selectedWorkType.largeWork,
            subcategory: selectedMediumWork,
            process: selectedProcess.rawValue,
            progressRate: Int(progressRate),
            workers: Int(selectedWorkerCount),
            startTime: accidentTime,
            riskScore: Int(prediction * 100) // 0.0~1.0을 0~100으로 변환
        )
        
        repository.addTask(
            category: newTask.category,
            subcategory: newTask.subcategory,
            process: newTask.process,
            progressRate: newTask.progressRate,
            workers: newTask.workers,
            startTime: newTask.startTime,
            riskScore: newTask.riskScore
        )
        
        print("💾 예측 결과를 작업으로 저장: 위험도 \(Int(prediction * 100))점")
        errorMessage = nil
    }
    
    @MainActor
    func predictRisk() {
        guard let model = model else {
            errorMessage = "모델이 로드되지 않았습니다."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // 변환 함수 사용
        let weatherString = selectedWeather.toModelValue()
        let constructionTypeString = "\(selectedWorkType.largeWork)/\(selectedMediumWork)"
        let processString = selectedProcess.rawValue
        let workerCountInt64 = selectedWorkerCount
        
        // 입력값 로그 출력
        print("🔍 === 예측 입력값 ===")
        print("  - weather: \(weatherString)")
        print("  - temperature: \(self.temperature)")
        print("  - humidity: \(self.humidity)")
        print("  - construction_type: \(constructionTypeString)")
        print("  - process: \(processString)")
        print("  - progress_rate: \(Int64(self.progressRate))")
        print("  - worker_count: \(workerCountInt64)")
        print("=========================")
        
        do {
            print("🚀 모델 예측 시작...")
            
            let output = try model.prediction(
                weather: weatherString,
                temperature: temperature,
                humidity: humidity,
                construction_type: constructionTypeString,
                process: processString,
                progress_rate: Int64(progressRate),
                worker_count: workerCountInt64
            )
            
            print("✅ 모델 예측 완료!")
            print("🔍 출력 피처: \(Array(output.featureNames))")
            
            if let riskValue = output.featureValue(for: "risk_index")?.doubleValue {
                prediction = riskValue
                print("✅ 예측 성공: risk_index = \(riskValue)")
            } else {
                errorMessage = "risk_index 값을 찾을 수 없습니다."
                print("❌ 예측 실패: risk_index 없음")
            }
        } catch {
            errorMessage = "예측 실패: \(error.localizedDescription)"
            print("❌ 예측 실패 오류: \(error)")
        }
        
        isLoading = false
    }
    

}

// MARK: - Enums
enum ProcessType: String, CaseIterable {
    case highAltitude = "고소"
    case structure = "골조"
    case excavation = "굴착"
    case finishing = "마감"
    case electrical = "설비"
    case welding = "용접"
    case transport = "운반"
    case cutting = "절단"
    case rebar = "철근"
    case demolition = "해체"
    case concrete = "콘크리트 타설"
    case cleanup = "정리"
    case other = "기타"
    
    var displayName: String {
        switch self {
        case .highAltitude: return "고소, 접근"
        case .structure: return "골조, 거푸집"
        case .excavation: return "굴착, 조성"
        case .finishing: return "마감, 도장"
        case .electrical: return "설비, 전기"
        case .welding: return "용접, 보수"
        case .transport: return "운반, 하역"
        case .cutting: return "절단, 가공"
        case .rebar: return "철근, 연결"
        case .demolition: return "해체, 철거"
        case .concrete: return "콘크리트 타설"
        case .cleanup: return "정리"
        case .other: return "기타"
        }
    }
}

// WorkerCount enum 제거 - 직접 Int64 값 사용
