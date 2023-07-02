//
//  SearchCoordinator.swift
//  GitHubList
//
//  Created by George Gomes on 02/07/23.
//

import Foundation
import GGDevelopmentKit

class SearchCoordinator: GGCoordinator {
    
    init(navigationController: UINavigationController) {
        super.init(rootViewController: navigationController)
    }

    override func start() {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: viewModel)
        
        viewModel.navigation
            .filter { $0.type == .back}
            .drive(onNext:  { [backToList] _ in
                backToList()
            })
            .disposed(by: viewController.disposeBag)
        
        viewModel.navigation
            .filter { $0.type == .searchUser}
            .map { $0.info as? SimpleUserProtocol }
            .unwrap()
            .drive(onNext:  { [openDetail] user in
                openDetail(user, self.rootViewController)
            })
            .disposed(by: viewController.disposeBag)
        
        show(viewController)
    }
    
    private func backToList() {
        pop()
    }
    
    private func openDetail(with user: SimpleUserProtocol, rootViewController: UIViewController) {
        
        let coordinator = UserDetailCoordinator(navigationController: self.rootViewController, with: user)
        coordinator.root(rootViewController)
        coordinator.start()
    }
}
