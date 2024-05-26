//
//  SplashView.swift
//  DogHouses
//
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var configModel: ConfigModel
    @Binding var configLoaded: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image(.logoWithDogs)
                .resizable()
                .scaledToFit()
            Text("Loading...")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .background {
            Image(.splashBack)
                .resizable()
                .ignoresSafeArea()
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

#Preview {
    SplashView(configLoaded: .constant(false))
        .environmentObject(ConfigModel.shared)
}
