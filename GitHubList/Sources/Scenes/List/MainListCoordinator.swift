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
        let viewModel = MainListViewModel()
        let viewController = MainListViewController(viewModel: viewModel)
        
        viewModel.navigation
            .filter { $0.type == .openDetail}
            .drive(onNext:  { [openDetail] _ in
                openDetail()
            })
            .disposed(by: viewController.disposeBag)
        
        show(viewController)
    }
    
    private func openDetail() {
        // TODO: - open detail
    }
}
