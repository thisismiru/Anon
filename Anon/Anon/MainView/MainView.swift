//
//  MainView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @State private var tasks: [ConstructionTask] = []
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            VStack {
                Text("오늘의 위험도 70%")
            }
            .background(.yellow)
            .onTapGesture {
                container.navigationRouter.push(to: .taskRiskListView)
            }
            
            List(tasks) { task in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.process)
                            .font(.headline)
                        
                        Text(task.startTime.toHourMinute())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(task.riskScore) 점")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("작업 리스트")
            .onTapGesture {
                container.navigationRouter.push(to: .taskDetailView(taskId: "1"))
            }
            .onAppear {
                tasks = container.taskRepository.fetchAllTasks(sortedBy: .startTime)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            }
        }
        .background(.red)
    }
}

#Preview {
    MainView()
}
