//
//  WorkProcessView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-24.
//

import SwiftUI

struct WorkProcessView: View {
    @Binding var selectedProcess: WorkProcess?

    private let columns = [
        GridItem(.flexible(), spacing: 9),
        GridItem(.flexible(), spacing: 9)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            ForEach(WorkProcess.allCases, id: \.self) { process in
                chip(title: process.title, isSelected: selectedProcess == process) {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.9)) {
                        selectedProcess = process
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func chip(title: String, isSelected: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(title)
                .font(.b1)
                .foregroundStyle(.neutral80)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? .blue10 : .neutral20)
                )
        }
        .buttonStyle(.plain)
    }
}
