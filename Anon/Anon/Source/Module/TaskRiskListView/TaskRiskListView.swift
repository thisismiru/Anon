//
//  TaskRiskListView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI
import SwiftData

struct TaskRiskListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: DIContainer
    @State private var tasks: [ConstructionTask] = []
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    NavigationBar(style: .simpleBack, onBack: { dismiss() })
                    Text("Today’s Works")
                        .font(.h5)
                        .foregroundStyle(.neutral100)
                }
                
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        if tasks.isEmpty {
                            VStack(spacing: 20) {
                                Spacer()
                                    .frame(height: 100)
                                
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.neutral40)
                                
                                Text("등록된 작업이 없습니다")
                                    .font(.h4)
                                    .foregroundStyle(.neutral70)
                                
                                Text("플러스 버튼을 눌러서 새로운 작업을 추가해보세요")
                                    .font(.b2)
                                    .foregroundStyle(.neutral60)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                                ForEach(tasks) { task in
                                    Button {
                                        container.navigationRouter.push(to: .taskRiskDetailView(taskId: task.id.uuidString))
                                    } label: {
                                        TaskRiskCard(
                                            time: task.startTime.toHourMinuteAmPm(),
                                            process: task.process,
                                            riskScore: task.riskScore
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
//                    PlusButton(action:{container.navigationRouter.push(to: .processAddView(taskId: ""))}
//                    )
//                    .frame(width: 56, height: 56)
//                    .padding(.trailing, 16)
//                    .safeAreaPadding(.bottom, 34)
                }
            }
            .padding(.top, 50)
            .ViewBG()
            .task {
                tasks = container.taskRepository.fetchAllTasks(sortedBy: .riskHighToLow)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let previewContainer = try! ModelContainer(
        for: ConstructionTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    TaskRiskListView()
        .environmentObject(DIContainer(
            navigationRouter: NavigationRouter(),
            modelContainer: previewContainer,
            modelContext: previewContainer.mainContext
        ))
}
