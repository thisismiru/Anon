//
//  AppFlowViewModel.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftData
import SwiftUI

@MainActor
class AppFlowViewModel: ObservableObject {
    @Published var appState: AppState = .splash
    private let context: ModelContext
    
    private let lastResetKey = "lastResetDate"
    
    enum AppState {
        case splash, addTask, main
    }
    
    init(context: ModelContext) {
        self.context = context
        self.appState = .splash
        scheduleMidnightReset()
    }
    
    /// 앱 활성화 시 자정이 지났는지 확인
    func checkIfMidnightPassed() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastReset = UserDefaults.standard.object(forKey: lastResetKey) as? Date ?? .distantPast
        
        if lastReset < today {
            resetData()
            UserDefaults.standard.set(Date(), forKey: lastResetKey)
        }
    }
    
    func checkInitialState() {
        var descriptor = FetchDescriptor<ConstructionTask>()
        descriptor.fetchLimit = 1
        let tasks = try? context.fetch(descriptor)
        appState = (tasks?.isEmpty ?? true) ? .addTask : .main
    }
    
    private func scheduleMidnightReset() {
        let now = Date()
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: now)
        comps.day! += 1
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        guard let midnight = Calendar.current.date(from: comps) else { return }
        
        let interval = midnight.timeIntervalSince(now)
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.resetData()
            UserDefaults.standard.set(Date(), forKey: self?.lastResetKey ?? "lastResetDate")
            self?.scheduleMidnightReset()
        }
    }
    
    private func resetData() {
        let descriptor = FetchDescriptor<ConstructionTask>()
        if let tasks = try? context.fetch(descriptor) {
            for task in tasks {
                context.delete(task)
            }
            try? context.save()
        }
        appState = .addTask
    }
}
