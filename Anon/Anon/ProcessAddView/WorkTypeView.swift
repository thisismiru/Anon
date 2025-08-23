import SwiftUI

struct WorkTypeView: View {
    @Binding var selectedWorkType: String?   // ✅ 외부와 바인딩

    @State private var selectedLarge: WorkType? = nil
    @State private var selectedMedium: String? = nil

    private var visibleLarge: [WorkType] {
        selectedLarge.map { [$0] } ?? WorkType.allCases
    }
    private var visibleMedium: [String] {
        guard let s = selectedLarge else { return [] }
        return selectedMedium.map { [$0] } ?? s.mediumWork
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Large chips
            FlowLayout(spacing: 12) {
                ForEach(visibleLarge, id: \.self) { large in
                    chipLarge(large)
                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                removal: .opacity.combined(with: .scale)))
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedLarge)

            // Medium chips
            if selectedLarge != nil {
                FlowLayout(spacing: 12) {
                    ForEach(visibleMedium, id: \.self) { medium in
                        chipMedium(medium)
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                    removal: .opacity.combined(with: .scale)))
                    }
                }
                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedMedium)
            }
        }
        .padding(20)
        // ✅ medium 선택이 바뀌면 외부(selectedWorkType)로 동기화
        // iOS 17+ 권장 시그니처
        .onChange(of: selectedMedium) { oldValue, newValue in
            selectedWorkType = newValue
        }
        // ✅ 외부에서 값이 이미 들어온 경우 내부 상태 복원
        .onAppear {
            guard let preset = selectedWorkType else { return }
            if let foundLarge = WorkType.allCases.first(where: { $0.mediumWork.contains(preset) }) {
                selectedLarge = foundLarge
                selectedMedium = preset
            }
        }
    }

    // MARK: - Chips

    private func chipLarge(_ type: WorkType) -> some View {
        let isSelected = (selectedLarge == type)
        return Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                if isSelected {
                    // large 해제 → medium/바인딩도 초기화
                    selectedLarge = nil
                    selectedMedium = nil    // <- onChange로 selectedWorkType도 nil 됨
                } else {
                    selectedLarge = type
                    selectedMedium = nil    // large 변경 시 medium 초기화
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(type.largeWork)
                    .font(.b1)
                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
                if isSelected { Image(.workXIcon) }
            }
            .padding(.leading, 24)
            .padding(.trailing, isSelected ? 12 : 24)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .blue5 : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func chipMedium(_ title: String) -> some View {
        let isSelected = (selectedMedium == title)
        return Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                let newValue: String? = (selectedMedium == title) ? nil : title  // ✅ 토글된 값
                selectedMedium   = newValue                                     // 로컬
                selectedWorkType = newValue                                     // 바인딩 동기화
            }
        } label: {
            HStack(spacing: 8) {
                Text(title)
                    .font(.b1)
                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
                if isSelected { Image(.workXIcon) }
            }
            .padding(.leading, 24)
            .padding(.trailing, isSelected ? 12 : 24)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8).inset(by: 0.5)
                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
