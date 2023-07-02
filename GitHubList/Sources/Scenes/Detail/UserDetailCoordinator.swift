//
//  UserDetailCoordinator.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import GGDevelopmentKit

class UserDetailCoordinator: GGCoordinator {
   
    let user: SimpleUserProtocol
    
    init(navigationController: UINavigationController, with user: SimpleUserProtocol) {
        self.user = user
        super.init(rootViewController: navigationController)
    }

    override func start() {
        let networlingManager = NetworkingManager()
        let service = UserDetailService(networkingManager: networlingManager)
        let viewModel = UserDetailViewModel(user: user, service: service)
        let viewController = UserDetailViewController(viewModel: viewModel)
        
        present(viewController)
    }
    
    private func openRepository() {
        // TODO: - Open repository
    }
}
