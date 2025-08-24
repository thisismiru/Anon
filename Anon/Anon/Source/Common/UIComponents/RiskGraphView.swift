//
//  RiskGraphView.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct RiskGraphView: View {
    let data: [HourlyRiskModel]
    let selectedHour: Int?
    
    private var maxScore: Int? { data.map { $0.score }.max() }
    private var minScore: Int? { data.map { $0.score }.min() }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .bottom) {
                    VStack(spacing: geo.size.height / 3) {
                        ForEach(0..<3) { i in
                            Rectangle()
                                .fill(i == 0 ? Color.clear : .neutral40)
                                .frame(height: 0.5)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    
                        HStack(alignment: .bottom, spacing: 20) {
                            ForEach(data) { item in
                                RiskBarView(
                                    item: item,
                                    isSelected: selectedHour == item.hour,
                                    isMax: item.score == maxScore,
                                    isMin: item.score == minScore
                                )
                            }
                        }
                        
                        Rectangle()
                            .fill(.neutral30)
                            .frame(height: 2)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 25)
                }
            }
        }
        .frame(height: 250)
    }
}

// MARK: - Single Bar Component

struct RiskBarView: View {
    let item: HourlyRiskModel
    let isSelected: Bool
    let isMax: Bool
    let isMin: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottom) {
                if isMin {
                    BestMarker()
                }
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(barColor)
                    .frame(width: 24, height: CGFloat(item.score) * 2)
            }
            
            if item.hour % 3 == 0 {
                Text("\(item.hour):00")
                    .font(.captionS)
                    .foregroundColor(.neutral50)
            } else {
                Text("\(item.hour):00")
                    .font(.captionS)
                    .foregroundColor(.clear)
            }
        }
        .padding(.horizontal, 2)
    }
    
    private var barColor: Color {
        if isMin {
            return .success
        }
        
        return .neutral20
    }
}

// MARK: - Best Marker
struct BestMarker: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Best")
                .font(.b2)
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
                .background(Color.neutral70)
                .cornerRadius(20)
                .foregroundStyle(.neutral0)
            
            GeometryReader { geo in
                Path { path in
                    let midX = geo.size.width / 2
                    path.move(to: CGPoint(x: midX, y: 0))
                    path.addLine(to: CGPoint(x: midX, y:  geo.size.height))
                }
                .stroke(style: StrokeStyle(lineWidth: 2,
                                           lineCap: .round,
                                           dash: [4, 4]))
                .foregroundColor(.neutral40)
            }
            
            Circle()
                .fill(Color.green)
                .frame(width: 12, height: 12)
        }
        .padding(.top, 14)
    }
}


#Preview {
    let sampleData = [
        HourlyRiskModel(hour: 9, score: 45),
        HourlyRiskModel(hour: 10, score: 60),
        HourlyRiskModel(hour: 11, score: 30),
        HourlyRiskModel(hour: 12, score: 75),
        HourlyRiskModel(hour: 13, score: 50),
        HourlyRiskModel(hour: 14, score: 20),
        HourlyRiskModel(hour: 15, score: 40)
    ]
    
    return RiskGraphView(data: sampleData, selectedHour: 12)
        .padding()
}
