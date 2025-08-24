//
//  ResetButtonSection.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct ResetButtonSection: View {
    @Binding var showingResetAlert: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Button {
                showingResetAlert = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                    
                    Text("SwiftData 초기화")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
            }
            
            Text("모든 저장된 작업 데이터가 삭제됩니다")
                .font(.caption)
                .foregroundColor(.neutral60)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
}
