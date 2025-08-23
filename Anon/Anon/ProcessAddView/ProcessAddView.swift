//
//  ProcessAddView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI

struct ProcessAddView: View {
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 8) {
                Text("공사 종류를 선택해주세요")
                    .foregroundStyle(.neutral100)
                    .font(.h3)
                Text("위험 판단과 체크리스트 추천에 사용됩니다")
                    .foregroundStyle(.neutral60)
                    .font(.b1)
                
                WorkTypePickerView()
            }
            
            Spacer()
        }
        .safeAreaPadding(.horizontal, 16)
    }
}

#Preview {
    ProcessAddView()
}
