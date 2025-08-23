//
//  PreditcView.swift
//  Anon
//
//  Created by 김재윤 on 8/23/25.
//

import SwiftUI
import CoreML
import SwiftData

struct PreditcView: View {
    @StateObject private var viewModel = PredictViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 헤더
                    VStack(spacing: 8) {
                        Text("건설 안전 위험도 예측")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("입력 정보를 바탕으로 위험도를 예측합니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // 입력 폼
                    VStack(spacing: 16) {
                        // 날짜 및 시간
                        VStack(alignment: .leading, spacing: 8) {
                            Text("사고 일시")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            DatePicker("", selection: $viewModel.accidentTime, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 날씨 선택
                        VStack(alignment: .leading, spacing: 8) {
                            Text("날씨")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Picker("날씨", selection: $viewModel.selectedWeather) {
                                ForEach(WeatherType.allCases, id: \.self) { weather in
                                    Text(weather.getKoreanName()).tag(weather)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 온도
                        VStack(alignment: .leading, spacing: 8) {
                            Text("온도 (°C)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Slider(value: $viewModel.temperature, in: -20...50, step: 0.5)
                                Text("\(viewModel.temperature, specifier: "%.1f")°C")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .frame(width: 80)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 습도
                        VStack(alignment: .leading, spacing: 8) {
                            Text("습도 (%)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Slider(value: $viewModel.humidity, in: 0...100, step: 1)
                                Text("\(Int(viewModel.humidity))%")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                    .frame(width: 60)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 공사 종류
                        VStack(alignment: .leading, spacing: 8) {
                            Text("공사 종류")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                // 대분류 선택
                                Picker("대분류", selection: $viewModel.selectedWorkType) {
                                    ForEach(WorkType.allCases, id: \.self) { workType in
                                        Text(workType.largeWork).tag(workType)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 120)
                                
                                // 중분류 선택
                                Picker("중분류", selection: $viewModel.selectedMediumWork) {
                                    ForEach(viewModel.selectedWorkType.mediumWork, id: \.self) { mediumWork in
                                        Text(mediumWork).tag(mediumWork)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 120)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 프로세스
                        VStack(alignment: .leading, spacing: 8) {
                            Text("프로세스")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Picker("프로세스", selection: $viewModel.selectedProcess) {
                                ForEach(ProcessType.allCases, id: \.self) { process in
                                    Text(process.displayName).tag(process)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 공정율
                        VStack(alignment: .leading, spacing: 8) {
                            Text("공정율 (%)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Slider(value: $viewModel.progressRate, in: 0...100, step: 1)
                                Text("\(Int(viewModel.progressRate))%")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                                    .frame(width: 60)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // 작업자 수
                        VStack(alignment: .leading, spacing: 8) {
                            Text("작업자 수")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Slider(value: Binding(
                                    get: { Double(viewModel.selectedWorkerCount) },
                                    set: { viewModel.selectedWorkerCount = Int64($0) }
                                ), in: 1...500, step: 1)
                                Text("\(viewModel.selectedWorkerCount)명")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                    .frame(width: 60)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // 예측 버튼
                    Button(action: {
                        Task {
                            await viewModel.predictRisk()
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(viewModel.isLoading ? "예측 중..." : "위험도 예측")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isLoading ? Color.gray : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                    
                    // 테스트용 간단한 예측 버튼
                    Button(action: {
                        // 간단한 테스트 값으로 예측
                        viewModel.accidentTime = Date()
                        viewModel.selectedWeather = .clear
                        viewModel.temperature = 25.0
                        viewModel.humidity = 60.0
                        viewModel.selectedWorkType = .building
                        viewModel.selectedMediumWork = "공동주택"
                        viewModel.selectedProcess = .cleanup
                        viewModel.progressRate = 30
                        viewModel.selectedWorkerCount = 500
                        print("🧪 === 테스트 값 설정 완료 ===")
                        Task {
                            await viewModel.predictRisk()
                        }
                    }) {
                        Text("🧪 테스트 예측 (간단한 값)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                    
                    // 작업 목록 표시
                    if !viewModel.tasks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("저장된 작업 목록")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ForEach(viewModel.tasks) { task in
                                Button(action: {
                                    viewModel.selectTask(task)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(task.category)/\(task.subcategory)")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text(task.process)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text("진행률: \(task.progressRate)% | 인원: \(task.workers)명")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("\(task.riskScore)점")
                                                .font(.headline)
                                                .foregroundColor(.red)
                                            Text(task.startTime.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // 예측 결과 저장 버튼
                    if viewModel.prediction > 0 {
                        Button(action: {
                            viewModel.savePredictionAsTask(to: modelContext)
                        }) {
                            Text("💾 예측 결과를 작업으로 저장")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                    }
                    
                    // 결과 표시
                    if viewModel.prediction > 0 {
                        VStack(spacing: 16) {
                            Text("예측 결과")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("위험도 지수:")
                                        .font(.headline)
                                    Spacer()
                                    Text("\(viewModel.prediction, specifier: "%.2f")")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(riskColor(for: viewModel.prediction))
                                }
                                
                                HStack {
                                    Text("위험 수준:")
                                        .font(.headline)
                                    Spacer()
                                    Text(riskLevel(for: viewModel.prediction))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(riskColor(for: viewModel.prediction))
                                }
                                
                                // 위험도 바
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("낮음")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                        Spacer()
                                        Text("높음")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                        }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color(.systemGray4))
                                                .frame(height: 8)
                                                .cornerRadius(4)
                                            
                                            Rectangle()
                                                .fill(riskColor(for: viewModel.prediction))
                                                .frame(width: geometry.size.width * min(viewModel.prediction / 100.0, 1.0), height: 8)
                                                .cornerRadius(4)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // 에러 메시지
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("위험도 예측")
            .onAppear {
                viewModel.loadTasks(from: modelContext)
            }
        }
    }
    
    private func riskColor(for value: Double) -> Color {
        if value < 0.3 {
            return .green
        } else if value < 0.7 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func riskLevel(for value: Double) -> String {
        if value < 0.3 {
            return "낮음"
        } else if value < 0.7 {
            return "보통"
        } else {
            return "높음"
        }
    }
    

}

#Preview {
    PreditcView()
}
