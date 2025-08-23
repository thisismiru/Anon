//
//  TaskRiskDetailView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct TaskRiskDetailView: View {
    @EnvironmentObject var container: DIContainer
    let taskId: String?
    
    var body: some View {
        Text("TaskRiskDetailView")
    }
}

#Preview {
    TaskRiskDetailView(taskId: "a")
}
