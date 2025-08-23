//
//  EditTaskView.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: DIContainer
    
    @State private var task: ConstructionTask?
    let taskId: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let task = task {
                    VStack(spacing: 16) {
                        WorkDetailRow(label: "Work Process", value: "\(task.process)", type: .purple)
                        WorkDetailRow(label: "Work Progress", value: "\(task.progressRate)%", type: .purple)
                        WorkDetailRow(label: "Number of Workers", value: "\(task.workers) workers", type: .purple)
                        WorkDetailRow(label: "Start Time", value: "\(task.startTime.toHourMinuteAmPm())", type: .purple)
                        
                        Spacer()
                    }
                    .padding(.top, 28)
                    .padding(.horizontal, 16)
                    
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
            }
            .onAppear {
                guard let idString = taskId, let id = UUID(uuidString: idString) else { return }
                task = container.taskRepository.fetchTask(by: id)
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Work Detail") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // TODO: - 저장 로직 (예: Repository update)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let previewContainer = try! ModelContainer(
        for: ConstructionTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = previewContainer.mainContext
    let dummy = ConstructionTask(
        category: "건축",
        subcategory: "골조공사",
        process: "철근 배근",
        progressRate: 30,
        workers: 5,
        startTime: Date(),
        riskScore: 65
    )
    context.insert(dummy)
    try? context.save()
    
    return EditTaskView(taskId: dummy.id.uuidString)
        .environmentObject(DIContainer(
            navigationRouter: NavigationRouter(),
            modelContainer: previewContainer,
            modelContext: context
        ))
}
