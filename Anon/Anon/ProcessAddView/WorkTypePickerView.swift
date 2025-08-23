import SwiftUI

struct Chip: Identifiable, Hashable {
    let id = UUID()
    let title: String
}

struct WorkTypePickerView: View {
    @State private var items: [Chip] = [
        .init(title: "공사 이름 1"),
        .init(title: "이름2"),
        .init(title: "미른"),
        .init(title: "공사 이름 2"),
        .init(title: "중분류1"),
        .init(title: "중분류2")
    ]
    @State private var selectedID: UUID? = nil

    private var visibleItems: [Chip] {
        if let s = selectedID, let only = items.first(where: { $0.id == s }) {
            return [only]
        }
        return items
    }

    // 칩 레이아웃 (자동 줄바꿈)
    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("공사 종류를 선택해주세요")
                .font(.title3).bold()

            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(visibleItems) { chip in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            selectedID = (selectedID == chip.id) ? nil : chip.id
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(chip.title)
                                .font(.subheadline).bold()
                            if selectedID == chip.id {
                                Image(systemName: "xmark")
                                    .font(.caption2.weight(.bold))
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedID == chip.id ? Color.blue.opacity(0.15) : Color.gray.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedID == chip.id ? Color.blue : Color.gray.opacity(0.35), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                            removal: .opacity.combined(with: .scale)))
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selectedID)

            Spacer()

            // 다음 버튼 (활성/비활성)
            Button {
                // next action
            } label: {
                Text("다음")
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(selectedID != nil ? .white : .gray)
                    .background(selectedID != nil ? Color.blue : Color.gray.opacity(0.15))
                    .cornerRadius(12)
            }
            .disabled(selectedID == nil)
        }
        .padding(20)
    }
}
