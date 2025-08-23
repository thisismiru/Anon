import SwiftUI

/// 0–90%, 10% 단위 스냅 슬라이더 (눈금 10개, 9등분)
struct WorkProgressView: View {
    @Binding var progress: Double   // 항상 0,10,20,…,90
    
    // 스타일
    private let trackHeight: CGFloat = 4
    private let thumbSize: CGFloat = 20
    private let tickSize: CGFloat = 8
    private let maxStep: Int = 9    // 0~90 (10% * 9)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            GeometryReader { geo in
                let width = geo.size.width
                
                // 트랙 레이어 (세로 기준면)
                Capsule()
                    .fill(.neutral20)
                    .frame(height: trackHeight)
                
                // 채워진 구간
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.blue50)
                            .frame(width: currentX(width: width), height: trackHeight)
                    }
                
                // 눈금 10개 (0~9)
                    .overlay {
                        HStack(spacing: 0) {
                            ForEach(0...maxStep, id: \.self) { i in
                                Circle()
                                    .fill(i <= currentStep ? .blue50 : Color.gray.opacity(0.35))
                                    .frame(width: tickSize, height: tickSize)
                                if i < maxStep { Spacer() }
                            }
                        }
                        .frame(height: trackHeight) // 트랙 중앙에 정확히 얹힘
                    }
                
                // 썸(핸들) — 세로는 자동 중앙, 가로만 오프셋
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(Color.blue)
                            .overlay(Circle().stroke(.blue10, lineWidth: 4))
                            .shadow(radius: 2, y: 1)
                            .frame(width: thumbSize, height: thumbSize)
                            .offset(x: currentX(width: width) - thumbSize / 2)
                    }
                
                // 히트 영역 확장 (트랙 높이 + 썸 여유)
                    .padding(.vertical, (thumbSize - trackHeight) / 2)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                snapUpdate(from: value.location.x, width: width)
                            }
                    )
            }
            .frame(height: max(thumbSize, trackHeight))      // 실제 뷰 높이
            .padding(.horizontal, 16)
            
            // 값 표시 (0,10,…,90)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(Int(progress))")
                    .font(Font.pretendard(type: .medium, size: 32))
                    .foregroundStyle(.neutral100)
                Text("%")
                    .font(.h4)
                    .foregroundStyle(.neutral100)
            }
            .padding(.horizontal, 16)
        }
    }
    
    // 현재 단계(0~9)
    private var currentStep: Int { Int(round(progress / 10.0)) }
    
    // 주어진 width에서 현재 X (0~width)
    private func currentX(width: CGFloat) -> CGFloat {
        let ratio = CGFloat(currentStep) / CGFloat(maxStep) // 0/9…9/9
        return max(0, min(width, ratio * width))
    }
    
    // 입력 x를 가까운 단계로 즉시 스냅하여 0,10,…,90 반영
    private func snapUpdate(from x: CGFloat, width: CGFloat) {
        let clampedX = max(0, min(width, x))
        let ratio = clampedX / width
        let snappedStep = Int((ratio * CGFloat(maxStep)).rounded()) // 0..9
        let snappedProgress = Double(snappedStep * 10)              // 0,10,…,90
        
        if Int(progress / 10) != snappedStep {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        progress = snappedProgress
    }
}
