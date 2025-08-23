//
//  HeadCountView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-24.
//

import SwiftUI

/// 인원 입력 뷰: 숫자만, 자동 포커스, workers 라벨 고정
struct HeadCountView: View {
    @Binding var headcount: Int?          // 외부와 바인딩
    @FocusState private var isFocused: Bool
    @State private var text: String = ""  // 내부 입력 버퍼(문자열)

    // 숫자 슬롯 고정 폭(라벨이 흔들리지 않도록)
    private let numberSlotWidth: CGFloat = 120  // 0~3자리까지 안정적(필요시 조정)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                TextField("0", text: $text)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .font(.system(size: 56, weight: .semibold))
                    .monospacedDigit()                       // 숫자 폭 고정
                    .multilineTextAlignment(.trailing)
                    .frame(width: numberSlotWidth, alignment: .trailing)  // ✅ 고정 폭
                    .textFieldStyle(.plain)

                Text("workers")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            // 외부 값이 있으면 동기화하고, 없으면 빈 값으로
            if let v = headcount { text = String(v) } else { text = "" }
            // 살짝 지연을 주면 포커스가 안정적으로 올라감
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isFocused = true                                // ✅ 자동 포커스 → 키보드 자동 표시
            }
        }
        // 입력 필터링: 숫자만 허용, 바인딩 반영
        .onChange(of: text) { old, new in
            let filtered = new.filter { $0.isNumber }
            if filtered != new {
                text = filtered
            }
            headcount = Int(filtered)
        }
        // 키보드 상단에 Done 버튼(넘버패드 닫기용)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFocused = false }
            }
        }
    }
}
