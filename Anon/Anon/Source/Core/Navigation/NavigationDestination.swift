//
//  NavigationDestination.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation

enum NavigationDestination: Equatable, Hashable {
    case processAddView(taskId: String)
    case mainView
    case taskRiskListView
    case taskRiskDetailView(taskId: String)
    case taskDetailView(taskId: String)
}
