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
            .frame(maxWidth: 199) // 휠 너비
            .padding(.vertical, 8)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
            .shadow(color: .black.opacity(0.1), radius: 30, x: 0, y: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // 가운데에 놓고 싶으면 .center
        .padding(.top, 8)
    }
}
