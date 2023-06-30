//
//  UserDetailCoordinator.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import GGDevelopmentKit

class UserDetailCoordinator: GGCoordinator {
   
    init(navigationController: UINavigationController) {
        super.init(rootViewController: navigationController)
    }

    override func start() {
        let viewModel = UserDetailViewModel()
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
