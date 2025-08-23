//
//  PlusButton.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct PlusButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "plus")
                .resizable()
                .foregroundStyle(.neutral0)
                .aspectRatio(contentMode: .fit)
        }
        .padding(16)
        .background {
            Circle().fill(Color.blue60)
        }
    }
}

#Preview {
    PlusButton(action: {})
        .frame(width: 56, height: 56)
}
