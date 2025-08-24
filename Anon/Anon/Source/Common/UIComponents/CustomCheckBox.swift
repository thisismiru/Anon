//
//  CustomCheckBox.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct CustomCheckBox: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isChecked.toggle()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isChecked ? Color.blue60 : Color.neutral20)
                    .frame(width: 24, height: 24)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .frame(width: 12, height: 9.4)
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isChecked1 = true
    @Previewable @State var isChecked2 = false
    
    VStack(spacing: 40) {
        CustomCheckBox(isChecked: $isChecked1)
        CustomCheckBox(isChecked: $isChecked2)
    }
}
