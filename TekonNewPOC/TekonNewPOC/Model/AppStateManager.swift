//
//  AppStateManager.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 26/11/23.
//

import UIKit


enum AppState {
    case foreground
    case background
}

class AppStateManager : NSObject {

    static let shared = AppStateManager()

    private(set) var appState: AppState = .foreground

    private override init() {
        // Private initializer to ensure only one instance of the manager
        super.init()
        setupObservers()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc private func appDidEnterBackground() {
        appState = .background
        // Handle background state
    }

    @objc private func appWillEnterForeground() {
        appState = .foreground
        // Handle foreground state
    }
}
/*
// Example usage
let appState = AppStateManager.shared.appState

if appState == .foreground {
    // Handle foreground state
} else {
    // Handle background state
}
*/
