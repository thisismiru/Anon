//
//  WorkDetailRow.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct WorkDetailRow: View {
    private let label: String
    private let value: String
    private let type: WorkDetailRowType
    
    init(label: String, value: String, type: WorkDetailRowType = .gray) {
        self.label = label
        self.value = value
        self.type = type
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.b1)
                .foregroundStyle(.neutral70)
            
            Spacer()
            
            Text(value)
                .font(.labelL)
                .foregroundStyle(type.textColor)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(type.bgColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(type.borderColor), lineWidth: 1)
                        )
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        WorkDetailRow(label: "Work Process", value: "Excavation")
        WorkDetailRow(label: "Work Progress", value: "60%")
        WorkDetailRow(label: "Number of Workers", value: "7 workers")
        WorkDetailRow(label: "Start Time", value: "8:00 AM")
    }
    .padding()
    .background(Color(.systemGray6))
}
