//
//  AnonApp.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import SwiftUI
import SwiftData

@main
struct AnonApp: App {
    var body: some Scene {
        WindowGroup {
            TaskRiskListView()
        }
        .modelContainer(for: ConstructionTask.self)
    }
}
