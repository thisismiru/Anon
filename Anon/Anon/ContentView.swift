//
//  ContentView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var container: DIContainer
    @State private var tasks: [ConstructionTask] = []

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(tasks) { task in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🕒 \(task.startTime.formatted(date: .numeric, time: .shortened))")
                            Text("공정: \(task.process)")
                            Text("진행률: \(task.progressRate)%")
                            Text("투입 인원: \(task.workers)명")
                            Text("위험 점수: \(task.riskScore)")
                        }
                        .padding()
                    } label: {
                        HStack {
                            Text(task.process)
                            Spacer()
                            Text("\(task.riskScore)점")
                                .foregroundColor(.red)
                        }
                    }
                }
                .onDelete { offsets in
                    offsets.map { tasks[$0] }.forEach { container.taskRepository.deleteTask($0) }
                    tasks = container.taskRepository.fetchAllTasks()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Dummy Task") {
                        container.taskRepository.addTask(
                            category: "건축",
                            subcategory: "골조공사",
                            process: "철근 배근",
                            progressRate: 30,
                            workers: 5,
                            startTime: Date(),
                            riskScore: 65
                        )
                        tasks = container.taskRepository.fetchAllTasks()
                    }
                }
            }
        } detail: {
            Text("작업을 선택하세요")
        }
        .onAppear {
            tasks = container.taskRepository.fetchAllTasks()
        }
    }
}

#Preview {
    ContentView()
}
