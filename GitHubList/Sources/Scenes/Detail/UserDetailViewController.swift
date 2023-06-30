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
    lazy var backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    
    // MARK: - Initializers
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupRX()
    }
    
    func setupRX() {
        backButton.rx
            .tap
            .bind(to: viewModel.didTapBack)
            .disposed(by: disposeBag)
    }
}

extension UserDetailViewController: ViewCoded {
    func setupViews() {
        view.addSubview(mainView)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViewConfigs() {
        mainView.backgroundColor = .blue
    }
    
    func setupConstraints() {
        mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainView.translatesAutoresizingMaskIntoConstraints = false
    }
}
