//
//  SplashView.swift
//  FruttyTreats
//
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var configModel: ConfigModel
    @Binding var configLoaded: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Loading...")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .background {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
        }
        .overlay(alignment: .center) {
            Image(.logo)
                .resizable()
                .scaledToFit()
        }
        .onAppear() {
            configModel.fetchConfig()
            AppDelegate.orientationLock = .portrait
        }
        .onChange(of: configModel.configLoaded) { _ in
            configLoaded = true
        }
    }
}
