//
//  NextButton.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import Foundation
import SwiftUI

enum NextButtonStyle {
    case enabled
    case disabled
    
    var color: Color {
        switch self {
        case .enabled:
            return .blue60
        case .disabled:
            return .neutral30
        }
    }
}

struct NextButton: View {
    var action: () -> Void
    var buttonStyle: NextButtonStyle = .disabled
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("다음")
                .foregroundStyle(.neutral0)
                .font(.h5)
                .frame(width: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(buttonStyle.color)
                )
        }

    }
}
