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
    
    let sampleData = [
        HourlyRiskModel(hour: 9, score: 45),
        HourlyRiskModel(hour: 10, score: 60),
        HourlyRiskModel(hour: 11, score: 30),
        HourlyRiskModel(hour: 12, score: 75),
        HourlyRiskModel(hour: 13, score: 50),
        HourlyRiskModel(hour: 14, score: 20),
        HourlyRiskModel(hour: 15, score: 40)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Color.back
                .frame(maxWidth: .infinity)
                .frame(height: 500)
                .offset(y: 100)
            
            ScrollView {
                VStack(spacing: 0) {
                    NavigationBar(style: .taskDetail,
                                  onBack: { dismiss() },
                                  onEdit: { showEditSheet = true },
                                  onDelete: { deleteTask()},
                    )
                    
                    Spacer()
                        .frame(height: 30)
                    
                    if let task = task {
                    
                    HorizontalPickerView(selectedIndex: $selectedIndex)
                        .padding(.top, 12)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    RiskGraphView(data: sampleData, selectedHour: 12)
                    
                    Spacer()
                        .frame(height: 51)
                    
                    HStack(spacing: 4) {
                        Text("\(task.progressRate)")
                            .font(.pretendard(type: .medium, size: 52))
                            .foregroundStyle(.neutral100)
                        
                        Text("pts")
                            .font(.h4)
                            .foregroundStyle(.neutral100)
                    }
                    
                    Spacer()
                        .frame(height: 117)
                    
                   
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
                .background(.white)
                .task {
                    loadTask()
                }
                .sheet(isPresented: $showEditSheet) {
                    EditTaskView(taskId: self.taskId)
                        .environmentObject(container)
                }
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
