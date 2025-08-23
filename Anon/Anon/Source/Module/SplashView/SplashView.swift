//
//  SplashView.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import SwiftUI
import SwiftData

struct SplashView: View {
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text("당신의 안전한 오늘을 위해,")
                    .font(.h5)
                    .foregroundStyle(.neutral0)
                
                Spacer()
                    .frame(height: 12)
                
                Text("안온")
                    .font(.h2)
                    .foregroundStyle(.neutral0)
                
                Spacer()
                    .frame(height: 100)
                
                Image(.mainlogo)
                
                Spacer()
                    .frame(height: 40)
                
                Text("ANON")
                    .font(.arialBlack(size: 23))
                    .foregroundStyle(.neutral0)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.blue50)
        .task {
            try? await Task.sleep(for: .seconds(2.5))
            appFlowViewModel.checkInitialState()
        }
    }
}

#Preview {
    SplashView()
}

#Preview {
    let container = try! ModelContainer(for: ConstructionTask.self)
    let context = container.mainContext
    
    SplashView()
        .environmentObject(AppFlowViewModel(context: context))
}
