//
//  UserDetailCoordinator.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import GGDevelopmentKit

class UserDetailCoordinator: GGCoordinator {
   
    let user: UserListModel
    
    init(navigationController: UINavigationController, with user: UserListModel) {
        self.user = user
        super.init(rootViewController: navigationController)
    }

    override func start() {
        let networlingManager = NetworkingManager()
        let service = UserDetailService(networkingManager: networlingManager)
        let viewModel = UserDetailViewModel(user: user, service: service)
        let viewController = UserDetailViewController(viewModel: viewModel)
        
        viewModel.navigation
            .filter { $0.type == .back}
            .drive(onNext:  { [backToList] _ in
                backToList()
            })
            .disposed(by: viewController.disposeBag)
        
        show(viewController)
    }
    
    private func backToList() {
        pop()
    }
    
    private func openRepository() {
        // TODO: - Open repository
    }
}
