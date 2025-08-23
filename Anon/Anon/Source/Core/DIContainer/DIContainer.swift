//
//  DIContainer.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation
import SwiftData

@MainActor
class DIContainer: ObservableObject {
    @Published var navigationRouter: NavigationRouter
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    let taskRepository: ConstructionTaskRepository
    
    init(
        navigationRouter: NavigationRouter = .init(),
        modelContainer: ModelContainer,
        modelContext: ModelContext
    ) {
        self.navigationRouter = navigationRouter
        self.modelContainer = modelContainer
        self.modelContext = modelContext
        self.taskRepository = ConstructionTaskRepository(context: modelContext)
    }
}
