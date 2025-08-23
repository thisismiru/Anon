import SwiftUI

struct Chip: Identifiable, Hashable {
    let id = UUID()
    let title: String
}

struct WorkTypeView: View {
    // 외부와 동기화될 바인딩
    @Binding var selectedLargeType: WorkType?   // 대분류(WorkType)
    @Binding var selectedWorkType: String?      // 소분류(String)

    // 내부 상태
    @State private var selectedLarge: WorkType? = nil
    @State private var selectedMedium: String? = nil

    // 보이는 목록
    private var visibleLarge: [WorkType] {
        selectedLarge.map { [$0] } ?? WorkType.allCases
    }
    private var visibleMedium: [String] {
        guard let s = selectedLarge else { return [] }
        return selectedMedium.map { [$0] } ?? s.mediumWork
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Large
            FlowLayout(spacing: 12) {
                ForEach(visibleLarge, id: \.self) { large in
                    chipLarge(large)
                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                removal: .opacity.combined(with: .scale)))
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedLarge)

            // Medium
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

        // 내부 → 외부 동기화
        .onChange(of: selectedLarge)  { _, new in selectedLargeType = new }
        .onChange(of: selectedMedium) { _, new in selectedWorkType  = new }

        // 외부 값이 있으면 내부 상태 복원
        .onAppear {
            if let presetLarge = selectedLargeType { selectedLarge = presetLarge }
            if let presetMedium = selectedWorkType,
               let foundLarge = WorkType.allCases.first(where: { $0.mediumWork.contains(presetMedium) }) {
                selectedLarge = foundLarge
                selectedMedium = presetMedium
            }
        }
    }

    // MARK: - Chips

    private func chipLarge(_ type: WorkType) -> some View {
        let isSelected = (selectedLarge == type)
        return Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                if isSelected {
                    // 해제
                    selectedLarge     = nil
                    selectedMedium    = nil
                    selectedLargeType = nil
                    selectedWorkType  = nil
                } else {
                    // 선택
                    selectedLarge     = type
                    selectedLargeType = type
                    selectedMedium    = nil
                    selectedWorkType  = nil
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
            .background(RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear))
            .overlay(
                RoundedRectangle(cornerRadius: 8).inset(by: 0.5)
                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func chipMedium(_ title: String) -> some View {
        let isSelected = (selectedMedium == title)
        return Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                let newValue = isSelected ? nil : title
                selectedMedium   = newValue
                selectedWorkType = newValue
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
            .background(RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear))
            .overlay(
                RoundedRectangle(cornerRadius: 8).inset(by: 0.5)
                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

//struct WorkTypeView: View {
//    
//    @State private var selectedLarge: WorkType? = nil
//    @State private var selectedMedium: String? = nil
//
//    private var visibleLarge: [WorkType] {
//        selectedLarge.map { [$0] } ?? WorkType.allCases
//    }
//    private var visibleMedium: [String] {
//        guard let s = selectedLarge else { return [] }
//        return selectedMedium.map { [$0] } ?? s.mediumWork
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//
//            // Large chips
//            FlowLayout(spacing: 12) {
//                ForEach(visibleLarge, id: \.self) { large in
//                    chipLarge(large)
//                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                                removal: .opacity.combined(with: .scale)))
//                }
//            }
//            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedLarge)
//
//            // Medium chips
//            if selectedLarge != nil {
//                FlowLayout(spacing: 12) {
//                    ForEach(visibleMedium, id: \.self) { medium in
//                        chipMedium(medium)
//                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                                    removal: .opacity.combined(with: .scale)))
//                    }
//                }
//                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedMedium)
//            }
//        }
//        .padding(20)
//    }
//
//    // MARK: - Chips
//
//    private func chipLarge(_ type: WorkType) -> some View {
//        let isSelected = (selectedLarge == type)
//        return Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                if isSelected {
//                    selectedLarge = nil
//                    selectedMedium = nil
//                } else {
//                    selectedLarge = type
//                    selectedMedium = nil
//                }
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(type.largeWork)
//                    .font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .padding(.leading, 24)
//            .padding(.trailing, isSelected ? 12 : 24)
//            .padding(.vertical, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(isSelected ? .blue5 : .clear)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .inset(by: 0.5)
//                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
//            )
//        }
//        .buttonStyle(.plain)
//    }
//
//    private func chipMedium(_ title: String) -> some View {
//        let isSelected = (selectedMedium == title)
//        return Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                selectedMedium = isSelected ? nil : title
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(title)
//                    .font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .padding(.leading, 24)
//            .padding(.trailing, isSelected ? 12 : 24)
//            .padding(.vertical, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(isSelected ? .blue5 : .clear)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .inset(by: 0.5)
//                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
//            )
//        }
//        .buttonStyle(.plain)
//    }
//}




//struct WorkTypeView: View {
//
//    @State private var items: [Chip] = [
//        .init(title: "공사 이름 1"),
//        .init(title: "이름2"),
//        .init(title: "미른"),
//        .init(title: "공사 이름 2"),
//        .init(title: "중분류1"),
//        .init(title: "중분류2")
//    ]
//    @State private var selectedID: UUID? = nil
//
//    private var visibleItems: [Chip] {
//        if let s = selectedID, let only = items.first(where: { $0.id == s }) {
//            return [only]
//        }
//        return items
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // 모든 칩을 한 줄로 배치
//            HStack(spacing: 12) {
//                ForEach(visibleItems) { chip in
//                    Button {
//                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                            selectedID = (selectedID == chip.id) ? nil : chip.id
//                        }
//                    } label: {
//                        HStack(spacing: 8) {
//                            Text(chip.title)
//                                .font(.b1)
//                                .foregroundStyle(selectedID == chip.id ? .blue80 : .neutral70)
//                            if selectedID == chip.id {
//                                Image(.workXIcon)
//                            }
//                        }
//                        .padding(.leading, 24)
//                        .padding(.trailing, selectedID == chip.id ? 12 : 24)
//                        .padding(.vertical, 10)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(selectedID == chip.id ? .blue5 : .clear)
//                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .inset(by: 0.5)
//                                .stroke(selectedID == chip.id ? .clear : .neutral30, lineWidth: 1)
//                        )
//                    }
//                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                            removal: .opacity.combined(with: .scale)))
//                }
//
//                Spacer()
//            }
//            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedID)
//        }
//        .padding(20)
//    }
//}

//struct WorkTypeView: View {
//
//    // 선택 상태
//    @State private var selectedLarge: WorkType? = nil
//    @State private var selectedMedium: String? = nil
//
//    // 표시 목록: large
//    private var visibleLarge: [WorkType] {
//        if let s = selectedLarge { return [s] }
//        return WorkType.allCases
//    }
//
//    // 표시 목록: medium (large 선택 시에만)
//    private var visibleMedium: [String] {
//        guard let s = selectedLarge else { return [] }
//        if let m = selectedMedium { return [m] }
//        return s.mediumWork
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//
//            // ── Large chips (상위) ─────────────────────────────
//            HStack(spacing: 12) {
//                ForEach(visibleLarge, id: \.self) { large in
//                    chipLarge(large)
//                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                                removal: .opacity.combined(with: .scale)))
//                }
//                Spacer()
//            }
//            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedLarge)
//
//            // ── Medium chips (하위, large 선택 시 노출) ─────────
//            if selectedLarge != nil {
//                HStack(spacing: 12) {
//                    ForEach(visibleMedium, id: \.self) { medium in
//                        chipMedium(medium)
//                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                                    removal: .opacity.combined(with: .scale)))
//                    }
//                    Spacer()
//                }
//                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedMedium)
//            }
//        }
//        .padding(20)
//    }
//
//    // MARK: - Chip views
//
//    @ViewBuilder
//    private func chipLarge(_ type: WorkType) -> some View {
//        let isSelected = (selectedLarge == type)
//        Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                if isSelected {
//                    // large 재탭 → large/medium 모두 해제 & large 전체 보이기
//                    selectedLarge = nil
//                    selectedMedium = nil
//                } else {
//                    // large 선택 → 그 칩만 남김, medium 전체 표시
//                    selectedLarge = type
//                    selectedMedium = nil
//                }
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(type.largeWork)
//                    .font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .padding(.leading, 24)
//            .padding(.trailing, isSelected ? 12 : 24)
//            .padding(.vertical, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(isSelected ? .blue5 : .clear)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .inset(by: 0.5)
//                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
//            )
//        }
//        .buttonStyle(.plain)
//    }
//
//    @ViewBuilder
//    private func chipMedium(_ title: String) -> some View {
//        let isSelected = (selectedMedium == title)
//        Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                // medium 토글: 선택→그 칩만, 다시 탭→전체 복원
//                selectedMedium = isSelected ? nil : title
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(title)
//                    .font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .padding(.leading, 24)
//            .padding(.trailing, isSelected ? 12 : 24)
//            .padding(.vertical, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(isSelected ? .blue5 : .clear)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .inset(by: 0.5)
//                    .stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
//            )
//        }
//        .buttonStyle(.plain)
//    }
//}

//struct WorkTypeView: View {
//    // 선택 상태
//    @State private var selectedLarge: WorkType? = nil
//    @State private var selectedMedium: String? = nil
//
//    // 보이는 목록
//    private var visibleLarge: [WorkType] {
//        selectedLarge.map { [$0] } ?? WorkType.allCases
//    }
//    private var visibleMedium: [String] {
//        guard let s = selectedLarge else { return [] }
//        return selectedMedium.map { [$0] } ?? s.mediumWork
//    }
//
//    // 고정 칩 폭/높이
//    private let chipWidth: CGFloat = 120
//    private let chipHeight: CGFloat = 40
//    private let spacing: CGFloat = 12
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//
//            // ── Large (상위) ────────────────────────────────
//            Wrap(visibleLarge, spacing: spacing) { large in
//                chipLarge(large)
//            }
//            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedLarge)
//
//            // ── Medium (하위, Large 선택 시 노출) ───────────
//            if selectedLarge != nil {
//                Wrap(visibleMedium, spacing: spacing) { medium in
//                    chipMedium(medium)
//                }
//                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedMedium)
//                .transition(.opacity.combined(with: .scale))
//            }
//        }
//        .padding(20)
//    }
//
//    // MARK: - Chip Views (고정폭)
//
//    @ViewBuilder
//    private func chipLarge(_ type: WorkType) -> some View {
//        let isSelected = (selectedLarge == type)
//        Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                if isSelected { selectedLarge = nil; selectedMedium = nil }   // 다시 누르면 전부 해제
//                else { selectedLarge = type; selectedMedium = nil }           // 선택 시 medium 전체 보임
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(type.largeWork)
//                    .font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .frame(width: chipWidth, height: chipHeight)  // ← 고정폭/고정높이
//            .background(RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear))
//            .overlay(RoundedRectangle(cornerRadius: 8).stroke(isSelected ? .clear : .neutral30, lineWidth: 1))
//        }
//        .buttonStyle(.plain)
//        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                removal: .opacity.combined(with: .scale)))
//    }
//
//    @ViewBuilder
//    private func chipMedium(_ title: String) -> some View {
//        let isSelected = (selectedMedium == title)
//        Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                selectedMedium = isSelected ? nil : title   // 다시 누르면 전체 복원
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(title)
//                    .font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .frame(width: chipWidth, height: chipHeight)  // ← 고정폭/고정높이
//            .background(RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear))
//            .overlay(RoundedRectangle(cornerRadius: 8).stroke(isSelected ? .clear : .neutral30, lineWidth: 1))
//        }
//        .buttonStyle(.plain)
//        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                removal: .opacity.combined(with: .scale)))
//    }
//}

//import SwiftUI
//
//struct WorkTypeView: View {
//    @State private var selectedLarge: WorkType? = nil
//    @State private var selectedMedium: String? = nil
//
//    private var visibleLarge: [WorkType] {
//        selectedLarge.map { [$0] } ?? WorkType.allCases
//    }
//    private var visibleMedium: [String] {
//        guard let s = selectedLarge else { return [] }
//        return selectedMedium.map { [$0] } ?? s.mediumWork
//    }
//
//    // 고정 칩 사이즈
//    private let chipWidth: CGFloat = 120
//    private let chipHeight: CGFloat = 40
//    private let spacing: CGFloat = 12
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//
//            // ⬇️ 기존 HStack/Wrap 대신 FlowLayout
//            FlowLayout(spacing: spacing) {
//                ForEach(visibleLarge, id: \.self) { large in
//                    chipLarge(large)
//                        .frame(width: chipWidth, height: chipHeight)
//                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                                removal: .opacity.combined(with: .scale)))
//                }
//            }
//            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedLarge)
//
//            if selectedLarge != nil {
//                FlowLayout(spacing: spacing) {
//                    ForEach(visibleMedium, id: \.self) { medium in
//                        chipMedium(medium)
//                            .frame(width: chipWidth, height: chipHeight)
//                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
//                                                    removal: .opacity.combined(with: .scale)))
//                    }
//                }
//                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedMedium)
//            }
//        }
//        .padding(20)
//    }
//
//    // MARK: - Chips (네가 쓰던 스타일 그대로)
//    private func chipLarge(_ type: WorkType) -> some View {
//        let isSelected = (selectedLarge == type)
//        return Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                if isSelected { selectedLarge = nil; selectedMedium = nil }
//                else { selectedLarge = type; selectedMedium = nil }
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(type.largeWork).font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .background(
//                RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8).stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
//            )
//        }
//        .buttonStyle(.plain)
//    }
//
//    private func chipMedium(_ title: String) -> some View {
//        let isSelected = (selectedMedium == title)
//        return Button {
//            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
//                selectedMedium = isSelected ? nil : title
//            }
//        } label: {
//            HStack(spacing: 8) {
//                Text(title).font(.b1)
//                    .foregroundStyle(isSelected ? .blue80 : .neutral70)
//                if isSelected { Image(.workXIcon) }
//            }
//            .background(
//                RoundedRectangle(cornerRadius: 8).fill(isSelected ? .blue5 : .clear)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8).stroke(isSelected ? .clear : .neutral30, lineWidth: 1)
//            )
//        }
//        .buttonStyle(.plain)
//    }
//}
