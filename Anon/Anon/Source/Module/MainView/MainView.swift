//
//  MainView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @Environment(\.modelContext) private var modelContext
    
    @State private var tasks: [ConstructionTask] = []
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            VStack(spacing: 16) {
                // 오늘의 진행도 카드
                TodayProgressCard(tasks: tasks)
                    .onTapGesture {
                        container.navigationRouter.push(to: .taskRiskListView)
                    }
                
                // SwiftData 초기화 버튼
                Button(action: {
                    showingResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                        Text("SwiftData 초기화")
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
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
        .alert("SwiftData 초기화", isPresented: $showingResetAlert) {
            Button("취소", role: .cancel) { }
            Button("초기화", role: .destructive) {
                resetSwiftData()
            }
        } message: {
            Text("모든 저장된 작업 데이터가 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.")
        }
    }
    
    // MARK: - SwiftData 초기화
    private func resetSwiftData() {
        do {
            // 모든 ConstructionTask 삭제
            try modelContext.delete(model: ConstructionTask.self)
            
            // 변경사항 저장
            try modelContext.save()
            
            // 로컬 tasks 배열도 초기화
            tasks.removeAll()
            
            print("SwiftData 초기화 완료")
        } catch {
            print("SwiftData 초기화 실패: \(error)")
        }
    }
}

#Preview {
    MainView()
}
