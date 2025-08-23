//
//  PredictViewModel.swift
//  Anon
//
//  Created by 김재윤 on 8/24/25.
//

import SwiftUI
import CoreML

// MARK: - ViewModel
class PredictViewModel: ObservableObject {
    @Published var accidentTime = Date()
    @Published var selectedWeather: WeatherType = .clear
    @Published var temperature: Double = 25.0
    @Published var humidity: Double = 60.0
    @Published var selectedConstructionType: ConstructionType = .buildingOffice
    @Published var selectedProcess: ProcessType = .demolition
    @Published var progressRate: Double = 50.0
    @Published var selectedWorkerCount: WorkerCount = .twentyToFortyNine
    
    @Published var prediction: Double?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var model: ANON?
    
    func loadModel() {
        do {
            model = try ANON()
            errorMessage = nil
        } catch {
            errorMessage = "모델 로딩 실패: \(error.localizedDescription)"
        }
    }
    
    func predictRisk() {
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
        let constructionTypeString = selectedConstructionType.rawValue
        let processString = selectedProcess.rawValue
        let workerCountString = selectedWorkerCount.rawValue
        
        // 예측 실행
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let output = try model.prediction(
                    accident_time: accidentTimeString,
                    weather: weatherString,
                    temperature: self.temperature,
                    humidity: self.humidity,
                    construction_type: constructionTypeString,
                    process: processString,
                    progress_rate: Int64(self.progressRate),
                    worker_count: workerCountString
                )
                
                DispatchQueue.main.async {
                    // 모델 출력의 모든 피처를 확인
                    print("🔍 모델 출력 피처들:")
                    for featureName in output.featureNames {
                        if let featureValue = output.featureValue(for: featureName) {
                            print("  - \(featureName): \(featureValue)")
                        }
                    }
                    
                    // risk_index 피처 찾기
                    if let riskValue = output.featureValue(for: "risk_index")?.doubleValue {
                        self.prediction = riskValue
                        print("✅ 예측 성공: risk_index = \(riskValue)")
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
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "예측 실패: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Enums
enum ConstructionType: String, CaseIterable {
    case buildingOffice = "building/office"
    case buildingResidential = "building/residential"
    case buildingFactory = "building/factory"
    case buildingEducational = "building/educational"
    case buildingCommercial = "building/commercial"
    case buildingCultural = "building/cultural"
    case retainingWall = "retaining_wall/retaining_wall"
    case tunnelRailway = "tunnel/railway_tunnel"
    case environmentalSewage = "environmental/sewage_treatment"
    case portOther = "port/other"
    
    var displayName: String {
        switch self {
        case .buildingOffice: return "건축물/업무시설"
        case .buildingResidential: return "건축물/공동주택"
        case .buildingFactory: return "건축물/공장"
        case .buildingEducational: return "건축물/교육연구시설"
        case .buildingCommercial: return "건축물/판매시설"
        case .buildingCultural: return "건축물/문화 및 집회시설"
        case .retainingWall: return "옹벽 및 절토사면/옹벽"
        case .tunnelRailway: return "터널/철도터널"
        case .environmentalSewage: return "환경시설/하수처리시설"
        case .portOther: return "항만/기타"
        }
    }
}

enum ProcessType: String, CaseIterable {
    case demolition = "demolition"
    case electrical = "electrical"
    case transportation = "transportation"
    case rebarConnection = "rebar_connection"
    case concretePouring = "concrete_pouring"
    case cleanup = "cleanup"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .demolition: return "해체, 철거"
        case .electrical: return "설비, 전기"
        case .transportation: return "운반, 하역"
        case .rebarConnection: return "철근, 연결"
        case .concretePouring: return "콘크리트 타설"
        case .cleanup: return "정리"
        case .other: return "기타"
        }
    }
}

enum WorkerCount: String, CaseIterable {
    case underNineteen = "under_19"
    case twentyToFortyNine = "20_49"
    case fiftyToNinetyNine = "50_99"
    case oneHundredToTwoHundredNinetyNine = "100_299"
    case threeHundredToFourHundredNinetyNine = "300_499"
    case overFiveHundred = "over_500"
    
    var displayName: String {
        switch self {
        case .underNineteen: return "19인 이하"
        case .twentyToFortyNine: return "20~49인"
        case .fiftyToNinetyNine: return "50~99인"
        case .oneHundredToTwoHundredNinetyNine: return "100~299인"
        case .threeHundredToFourHundredNinetyNine: return "300~499인"
        case .overFiveHundred: return "500인 이상"
        }
    }
}
