//
//  NavigationBar.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI

enum NavigationBarStyle {
    /// 온보딩 화면처럼 좌측 Back만 있는 버전
    case simpleBack
    /// 상세 화면처럼 좌측 Back + 우측 Edit/Delete
    case taskDetail
}

struct NavigationBar: View {
    let style: NavigationBarStyle
    var onBack: () -> Void = {}
    var onEdit: () -> Void = {}
    var onDelete: () -> Void = {}

    var body: some View {
        HStack {
            // Left
            Button(action: onBack) {
                Image(.navigationBarBack)
                    .frame(width: 24, height: 24)
            }

            Spacer()

            // Right (style에 따라 다름)
            switch style {
            case .simpleBack:
                EmptyView()

            case .taskDetail:
                HStack(spacing: 12) {
                    Button(action: onEdit) {
                        Image(.navigationBarEdit)
                            .frame(width: 24, height: 24)
                    }
                    Button(action: onDelete) {
                        Image(.navigationBarTrash)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
