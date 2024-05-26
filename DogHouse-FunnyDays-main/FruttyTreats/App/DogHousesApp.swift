//
//  DogHousesApp.swift
//  DogHouses
//
//

import SwiftUI

@main
struct DogHousesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var configLoaded: Bool = false
    
    // MARK: - Models
    @State private var configModel: ConfigModel = ConfigModel.shared

    var body: some Scene {
        WindowGroup {
            if configLoaded, configModel.availableLink.isEmpty {
                MainView()
            } else if !configModel.availableLink.isEmpty {
                AdditionalView(link: configModel.availableLink)
            } else {
                SplashView(configLoaded: $configLoaded)
                    .environmentObject(configModel)
            }
        }
    }
}
