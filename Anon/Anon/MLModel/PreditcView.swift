//
//  PreditcView.swift
//  Anon
//
//  Created by 김재윤 on 8/23/25.
//

import SwiftUI
import CoreML

struct PreditcView: View {
    @StateObject private var viewModel = PredictViewModel()
    
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
                            
                            Picker("공사 종류", selection: $viewModel.selectedConstructionType) {
                                ForEach(ConstructionType.allCases, id: \.self) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
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
                            
                            Picker("작업자 수", selection: $viewModel.selectedWorkerCount) {
                                ForEach(WorkerCount.allCases, id: \.self) { count in
                                    Text(count.displayName).tag(count)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // 예측 버튼
                    Button(action: {
                        viewModel.predictRisk()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "brain.head.profile")
                            }
                            Text(viewModel.isLoading ? "예측 중..." : "위험도 예측하기")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(viewModel.isLoading ? Color.gray : Color.blue)
                        .cornerRadius(16)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal)
                    
                    // 결과 표시
                    if let prediction = viewModel.prediction {
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
                                    Text("\(prediction, specifier: "%.2f")")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(riskColor(for: prediction))
                                }
                                
                                HStack {
                                    Text("위험 수준:")
                                        .font(.headline)
                                    Spacer()
                                    Text(riskLevel(for: prediction))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(riskColor(for: prediction))
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
                                                .fill(riskColor(for: prediction))
                                                .frame(width: geometry.size.width * min(prediction / 100.0, 1.0), height: 8)
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
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.loadModel()
        }
    }
    
    private func riskColor(for value: Double) -> Color {
        if value < 30 {
            return .green
        } else if value < 70 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func riskLevel(for value: Double) -> String {
        if value < 30 {
            return "낮음"
        } else if value < 70 {
            return "보통"
        } else {
            return "높음"
        }
    }
}

#Preview {
    PreditcView()
}
