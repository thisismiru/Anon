//
//  NextButton.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import Foundation
import SwiftUI

enum NextButtonType {
    case next      // 기본 "Next"
    case start     // "Start Your Day Safely"
    case save      // 정보 수정 후는 save
    
    var title: String {
        switch self {
        case .next:  return "Next"
        case .start: return "Start Your Day Safely"
        case .save:  return "Save"
        }
    }
}

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
    var buttonType: NextButtonType = .next
    var buttonStyle: NextButtonStyle = .disabled
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonType.title)
                .foregroundStyle(.neutral0)
                .font(.h5)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(buttonStyle.color)
                )
        }
        .disabled(buttonStyle == .disabled)

    }
}
