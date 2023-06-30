//
//  SceneDelegate.swift
//  GitHubList
//
//  Created by George Gomes on 29/06/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
            guard let windowScene = (scene as? UIWindowScene) else { return }

            let window = UIWindow(windowScene: windowScene)
            window.frame = UIScreen.main.bounds
            window.makeKeyAndVisible()
            
            appCoordinator = AppCoordinator(window: window)
            self.appCoordinator.start()
            
            self.window = window
    }

}

