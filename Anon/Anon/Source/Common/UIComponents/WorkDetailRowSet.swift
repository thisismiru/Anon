//
//  WorkDetailRowSet.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct WorkDetailRowSet: View {
    private let process: String
    private let progress: Int
    private let workers: Int
    private let startTime: String
    private let type: WorkDetailRowType
    
    init(process: String, progress: Int, workers: Int, startTime: String, type: WorkDetailRowType = .gray) {
        self.process = process
        self.progress = progress
        self.workers = workers
        self.startTime = startTime
        self.type = type
    }
    
    var body: some View {
        VStack(spacing: 16) {
            WorkDetailRow(label: "Work Process", value: "\(process)", type: type)
            WorkDetailRow(label: "Work Progress", value: "\(progress)%", type: type)
            WorkDetailRow(label: "Number of Workers", value: "\(workers)workers", type: type)
            WorkDetailRow(label: "Start Time", value: "\(startTime)", type: type)
        }
    }
}

#Preview {
    VStack {
        WorkDetailRowSet(process: "Excavation",
                         progress: 60,
                         workers: 7,
                         startTime: "8:00 AM"
        )
        .background(Color(.systemGray6))
        
        WorkDetailRowSet(process: "Excavation",
                         progress: 60,
                         workers: 7,
                         startTime: "8:00 AM",
                         type: .purple
        )
    }
    .padding()
}
