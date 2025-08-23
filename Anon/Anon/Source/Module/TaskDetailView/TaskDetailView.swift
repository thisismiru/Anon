//
//  TaskDetailView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var container: DIContainer
    let taskId: String?
    
    var body: some View {
        Text("TaskDetailView")
    }
}

#Preview {
    TaskDetailView(taskId: "a")
}
