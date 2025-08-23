//
//  TaskRiskListView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI
import SwiftData

struct TaskRiskListView: View {
    @Query private var tasks: [ConstructionTask]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                          spacing: 16) {
                    ForEach(tasks) { task in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(task.startTime.toHourMinute())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(task.process)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            HStack {
                                Text("\(task.riskScore)")
                                    .font(.system(size: 28, weight: .bold))
                                Text("점")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        .frame(height: 120)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    TaskRiskListView()
        .modelContainer(for: ConstructionTask.self, inMemory: true)
}
