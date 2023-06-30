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
    
    private let viewController: MainListViewController
    private let viewModel: MainListViewModelProtocol
    
    let mainNavigationViewController: UINavigationController
       
    init(window: UIWindow) {
        self.window = window
       
        mainNavigationViewController = UINavigationController()
        coordinator = MainListCoordinator(navigationController: mainNavigationViewController)
        
        window.rootViewController = mainNavigationViewController
        
        viewModel = MainListViewModel()
        viewController = MainListViewController(viewModel: viewModel)
        
        super.init(rootViewController: window.rootViewController)
        
    }
    
    override func start() {
        
        coordinator.start()
    }
}
