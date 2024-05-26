//
//  ConfigModel.swift
//  DogHouses
//
//

import Foundation
import FirebaseRemoteConfig
import SwiftUI

final class ConfigModel: ObservableObject {
    // MARK: - Public properties
    static let shared = ConfigModel()
    @Published var configLoaded: Bool = false

    // MARK: - Config values
    @Published var availableLink: String = ""

    // MARK: - Private properties
    private var config: RemoteConfig?
    
    // MARK: - Public methods
    func fetchConfig() {
        self.config = RemoteConfig.remoteConfig()
        config?.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                print("DEBUG: REMOTE CONFIG FETCHED")
                self?.config?.activate()
            } else {
                print("DEBUG: ERROR WHILE FETCH CONFIG")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self?.availableLink = self?.config?[ConfigKeys.availableLink.rawValue].stringValue ?? ""
                self?.configLoaded = true
            }
        }
    }
}
