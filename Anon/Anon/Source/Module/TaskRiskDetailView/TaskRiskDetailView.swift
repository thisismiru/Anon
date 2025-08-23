//
//  TaskRiskDetailView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI
import SwiftData

struct TaskRiskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: DIContainer
    
    @State private var task: ConstructionTask?
    let taskId: String?
    
    @State private var selectedIndex: Int = 0
    @State private var showEditSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ZStack {
                    NavigationBar(style: .taskDetail,
                                  onBack: { dismiss() },
                                  onEdit: { showEditSheet = true },
                                  onDelete: { deleteTask()},
                    )
                    Text("Today’s Works")
                        .font(.h5)
                        .foregroundStyle(.neutral100)
                }
                
                HorizontalPickerView(selectedIndex: $selectedIndex)
                    .padding(.top, 12)
                
                if let task = task {
                    VStack(spacing: 16) {
                        Text("Work Details")
                            .font(.h4)
                            .foregroundStyle(.neutral100)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        WorkDetailRow(label: "Work Process", value: "\(task.process)")
                        WorkDetailRow(label: "Work Progress", value: "\(task.progressRate)%")
                        WorkDetailRow(label: "Number of Workers", value: "\(task.workers) workers")
                        WorkDetailRow(label: "Start Time", value: "\(task.startTime.toHourMinuteAmPm())")
                        
                        Spacer()
                    }
                    .padding(.top, 28)
                    .padding(.horizontal, 16)
                    .background(.back)
                    
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                loadTask()
            }
            .sheet(isPresented: $showEditSheet) {
                EditTaskView(taskId: self.taskId)
                    .environmentObject(container)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Methods
    
    private func loadTask() {
        guard let idString = taskId, let id = UUID(uuidString: idString) else { return }
        task = container.taskRepository.fetchTask(by: id)
    }
    
    private func deleteTask() {
        guard let task = task else { return }
        container.taskRepository.deleteTask(task)
        dismiss()
    }
}

#Preview {
    let previewContainer = try! ModelContainer(
        for: ConstructionTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = previewContainer.mainContext
    
    // 더미 task 생성
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
    
    return TaskRiskDetailView(taskId: dummy.id.uuidString)
        .environmentObject(DIContainer(
            navigationRouter: NavigationRouter(),
            modelContainer: previewContainer,
            modelContext: context
        ))
}
