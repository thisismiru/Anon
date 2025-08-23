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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var di: DIContainer
    @StateObject private var appFlowViewModel: AppFlowViewModel

    init() {
        let container = try! ModelContainer(for: ConstructionTask.self)
        let context = container.mainContext
        
        _di = StateObject(wrappedValue: DIContainer(modelContainer: container, modelContext: context))
        _appFlowViewModel = StateObject(wrappedValue: AppFlowViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            switch appFlowViewModel.appState {
            case .splash:
                SplashView()
                    .environmentObject(appFlowViewModel)
            case .addTask:
                ProcessAddView(taskId: "")
                    .environmentObject(di)
                    .environmentObject(appFlowViewModel)
            case .main:
                MainView()
                    .environmentObject(di)
                    .environmentObject(appFlowViewModel)
            }
        }
        .modelContainer(for: ConstructionTask.self)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                appFlowViewModel.checkIfMidnightPassed()
            }
        }
    }
}
