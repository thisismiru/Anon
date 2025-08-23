//
//  SplashView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    var body: some View {
        VStack {
            Text("Splash")
        }
        .ignoresSafeArea()
        .background(.blue)
        .task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            appFlowViewModel.appState = .main
        }
    }
}

#Preview {
    SplashView()
}
