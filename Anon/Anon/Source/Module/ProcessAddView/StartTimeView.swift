import SwiftUI

/// 작업 시작 시간 선택 뷰 (Wheel, 시간/분만)
struct StartTimeView: View {
    @Binding var startTime: Date
    
    var body: some View {
        VStack(spacing: 24) {
            DatePicker(
                "",
                selection: $startTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: 320)
            .padding(.vertical, 8)
            // **여기서 배경과 그림자를 따로 분리**
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 24, y: 8) // <- 그림자
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 8)
    }
}
