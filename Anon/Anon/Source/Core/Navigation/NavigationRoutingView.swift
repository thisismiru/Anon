//
//  NavigationRoutingView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .mainView:
                MainView()
            case .processAddView:
                ProcessAddView(container: _container)
            case .taskRiskListView:
                TaskRiskListView()
            case .taskDetailView(let taskId):
                TaskDetailView(container: _container, taskId: taskId)
            case .taskRiskDetailView(let taskId):
                TaskRiskDetailView(container: _container, taskId: taskId)
            }
        }
        .environmentObject(container)
    }
}
