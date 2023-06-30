//
//  UserDetailViewController.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import UIKit
import RxSwift
import RxCocoa
import GGDevelopmentKit

class UserDetailViewController: UIViewController, GGAlertableViewController {
    
    private var viewModel: UserDetailViewModelProtocol
    let disposeBag = DisposeBag()
    
    lazy var mainView = UIView()
    
    // MARK: - Initializers
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        view.addSubview(mainView)
        
        mainView.backgroundColor = .blue
        
        mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainView.translatesAutoresizingMaskIntoConstraints = false
    }
}
