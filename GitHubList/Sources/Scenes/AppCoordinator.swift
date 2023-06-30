//
//  AppCoordinator.swift
//  GitHubList
//
//  Created by George Gomes on 29/06/23.
//

import Foundation
import GGDevelopmentKit

class AppCoordinator: GGBaseCoordinator<UIViewController> {
    
    private let window: UIWindow
    private let coordinator: MainListCoordinator
    
    let mainNavigationViewController: UINavigationController
       
    init(window: UIWindow) {
        self.window = window
       
        mainNavigationViewController = UINavigationController()
        coordinator = MainListCoordinator(navigationController: mainNavigationViewController)
        
        window.rootViewController = mainNavigationViewController
        
        super.init(rootViewController: mainNavigationViewController)
    }
    
    override func start() {
        
        coordinator.start()
    }
}
