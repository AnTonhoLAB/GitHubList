//
//  MainListCoordinator.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import GGDevelopmentKit

class MainListCoordinator: GGCoordinator {
   
    init(navigationController: UINavigationController) {
        super.init(rootViewController: navigationController)
    }

    override func start() {
        let networkManager = NetworkingManager()
        let service = MainListService(networkingManager: networkManager)
        let viewModel = MainListViewModel(service: service)
        let viewController = MainListViewController(viewModel: viewModel)
        
        viewModel.navigation
            .filter { $0.type == .openDetail}
            .map { $0.info as? UserListModel }
            .unwrap()
            .drive(onNext:  { [openDetail] userToOpen in
                
                openDetail(userToOpen, viewController)
            })
            .disposed(by: viewController.disposeBag)
        
        root(viewController)
    }
    
    private func openDetail(with user: UserListModel, rootViewController: UIViewController) {
        let coordinator = UserDetailCoordinator(navigationController: self.rootViewController, with: user)
        coordinator.root(rootViewController)
        coordinator.start()
    }
}
