//
//  AppDelegate.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 21/1/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let window =  UIWindow(frame: UIScreen.main.bounds)

        applyThemeStyles()
        
        appCoordinator = ApplicationFlowCoordinator(window: window,
                                                    dependencyProvider: ApplicationComponentsFactory())
        appCoordinator.start()

        self.window = window
        self.window?.makeKeyAndVisible()

        return true
    }

    
    // MARK: - Private Helpers
    
    private func applyThemeStyles() {
        window?.backgroundColor = .white
        window?.tintColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
    }
}

