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
    @Published var selectedProcess: ProcessType = .foundation
    @Published var progressRate: Double = 30.0
    @Published var selectedWorkerCount: WorkerCount = .five
    
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
            model = try ANON()
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
        
        // workers를 기반으로 WorkerCount 설정
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
        // workers 수를 기반으로 WorkerCount 찾기
        switch task.workers {
        case 1...4:
            selectedWorkerCount = .oneToFour
        case 5...9:
            selectedWorkerCount = .five
        case 10...19:
            selectedWorkerCount = .tenToNineteen
        case 20...49:
            selectedWorkerCount = .twentyToFortyNine
        case 50...99:
            selectedWorkerCount = .fiftyToNinetyNine
        case 100...:
            selectedWorkerCount = .hundredPlus
        default:
            selectedWorkerCount = .five
        }
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
            workers: selectedWorkerCount.toWorkerCount(),
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
    func predictRisk() async {
        guard let model = model else {
            errorMessage = "모델이 로드되지 않았습니다."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // 입력값 준비
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let accidentTimeString = dateFormatter.string(from: accidentTime)
        
        let weatherString = selectedWeather.toModelValue()
        let constructionTypeString = "\(selectedWorkType.largeWork)/\(selectedMediumWork)"
        let processString = selectedProcess.rawValue
        let workerCountString = selectedWorkerCount.rawValue
        
        // 입력값 로그 출력
        print("🔍 === 예측 입력값 ===")
        print("  - accident_time: \(accidentTimeString)")
        print("  - weather: \(weatherString)")
        print("  - temperature: \(self.temperature)")
        print("  - humidity: \(self.humidity)")
        print("  - construction_type: \(constructionTypeString)")
        print("  - process: \(processString)")
        print("  - progress_rate: \(Int64(self.progressRate))")
        print("  - worker_count: \(workerCountString)")
        print("  - selectedWeather: \(selectedWeather)")
        print("  - selectedWorkType: \(selectedWorkType)")
        print("  - selectedMediumWork: \(selectedMediumWork)")
        print("  - selectedProcess: \(selectedProcess)")
        print("  - selectedWorkerCount: \(selectedWorkerCount)")
        print("=========================")
        
        // 예측 실행 (async/await 방식)
        do {
            print("🚀 모델 예측 시작...")
            
            let output = try await model.prediction(
                accident_time: accidentTimeString,
                weather: weatherString,
                temperature: self.temperature,
                humidity: self.humidity,
                construction_type: constructionTypeString,
                process: processString,
                progress_rate: Int64(self.progressRate),
                worker_count: workerCountString
            )
            
            print("✅ 모델 예측 완료!")
            
            // 모델 출력의 모든 피처를 확인
            print("🔍 === 모델 출력 피처들 ===")
            print("  - 전체 피처 개수: \(output.featureNames.count)")
            print("  - 피처 이름들: \(Array(output.featureNames))")
            
            for featureName in output.featureNames {
                if let featureValue = output.featureValue(for: featureName) {
                    print("  - \(featureName): \(featureValue) (타입: \(type(of: featureValue)))")
                } else {
                    print("  - \(featureName): nil")
                }
            }
            print("=========================")
            
            // ANONOutput의 risk_index 속성으로 직접 접근
            print("🎯 risk_index 속성 접근 시도...")
            do {
                let riskValue = output.risk_index
                self.prediction = riskValue
                print("✅ 예측 성공: risk_index = \(riskValue)")
            } catch {
                // risk_index 속성 접근 실패 시 fallback
                print("⚠️ risk_index 속성 접근 실패: \(error)")
                print("⚠️ 피처 이름으로 시도...")
                
                if let riskValue = output.featureValue(for: "risk_index")?.doubleValue {
                    self.prediction = riskValue
                    print("✅ 피처 이름으로 찾음: risk_index = \(riskValue)")
                } else {
                    // 다른 가능한 피처 이름들 시도
                    let possibleNames = ["risk_index", "risk", "prediction", "output", "result"]
                    var foundValue: Double?
                    
                    for name in possibleNames {
                        if let value = output.featureValue(for: name)?.doubleValue {
                            foundValue = value
                            print("✅ 다른 이름으로 찾음: \(name) = \(value)")
                            break
                        }
                    }
                    
                    if let finalValue = foundValue {
                        self.prediction = finalValue
                    } else {
                        self.errorMessage = "risk_index 피처를 찾을 수 없습니다. 출력된 피처: \(Array(output.featureNames))"
                        print("❌ 예측 실패: 사용 가능한 피처 = \(Array(output.featureNames))")
                    }
                }
            }
            
        } catch {
            print("❌ 모델 예측 실패: \(error)")
            self.errorMessage = "예측 실패: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    

}

// MARK: - Enums
enum ProcessType: String, CaseIterable {
    case demolition = "demolition"
    case electrical = "electrical"
    case transportation = "transportation"
    case rebarConnection = "rebar_connection"
    case concretePouring = "concrete_pouring"
    case foundation = "foundation"
    case cleanup = "cleanup"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .demolition: return "해체, 철거"
        case .electrical: return "설비, 전기"
        case .transportation: return "운반, 하역"
        case .rebarConnection: return "철근, 연결"
        case .concretePouring: return "콘크리트 타설"
        case .foundation: return "기초공사"
        case .cleanup: return "정리"
        case .other: return "기타"
        }
    }
}

enum WorkerCount: String, CaseIterable {
    case oneToFour = "1_4"
    case five = "5_9"
    case tenToNineteen = "10_19"
    case twentyToFortyNine = "20_49"
    case fiftyToNinetyNine = "50_99"
    case hundredPlus = "100+"
    
    var displayName: String {
        switch self {
        case .oneToFour: return "1~4인"
        case .five: return "5~9인"
        case .tenToNineteen: return "10~19인"
        case .twentyToFortyNine: return "20~49인"
        case .fiftyToNinetyNine: return "50~99인"
        case .hundredPlus: return "100인 이상"
        }
    }
    
    func toWorkerCount() -> Int {
        switch self {
        case .oneToFour: return 3
        case .five: return 7
        case .tenToNineteen: return 15
        case .twentyToFortyNine: return 35
        case .fiftyToNinetyNine: return 75
        case .hundredPlus: return 150
        }
    }
}
