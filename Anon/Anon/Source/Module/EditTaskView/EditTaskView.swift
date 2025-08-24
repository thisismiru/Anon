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
    @State private var showEditSheet = false
    @State private var editStep: OnboardingStep = .workType
    let taskId: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let task = task {
                    VStack(spacing: 16) {
                        Button {
                            editStep = .workProcess
                            showEditSheet = true
                        } label: {
                            WorkDetailRow(label: "Work Process", value: "\(task.process)", type: .purple)
                        }

                        Button {
                            editStep = .workProgress
                            showEditSheet = true
                        } label: {
                            WorkDetailRow(label: "Work Progress", value: "\(task.progressRate)%", type: .purple)
                        }

                        Button {
                            editStep = .headcount
                            showEditSheet = true
                        } label: {
                            WorkDetailRow(label: "Number of Workers", value: "\(task.workers) workers", type: .purple)
                        }

                        Button {
                            editStep = .startTime
                            showEditSheet = true
                        } label: {
                            WorkDetailRow(label: "Start Time", value: "\(task.startTime.toHourMinuteAmPm())", type: .purple)
                        }

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
            .task {
                guard let idString = taskId, let id = UUID(uuidString: idString) else { return }
                task = container.taskRepository.fetchTask(by: id)
            }
            .sheet(isPresented: $showEditSheet) {
                ProcessAddView(taskId: self.taskId, step: editStep)
                    .environmentObject(container)
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Work Detail")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
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
