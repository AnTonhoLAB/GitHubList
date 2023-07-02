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
        
        viewModel
            .viewDidLoad
            .onNext(true)
    }
    
    func setupRX() {
        backButton.rx
            .tap
            .bind(to: viewModel.didTapBack)
            .disposed(by: disposeBag)
        
        viewModel.serviceState
                    .filter { $0.type == .loading }
                    .drive { state in
                        self.view.showLoading()
                    }
                    .disposed(by: disposeBag)
        
        viewModel.serviceState
                    .filter { $0.type == .success }
                    .drive { object in
                        self.view.removeLoading()
                    }
                    .disposed(by: disposeBag)
        
        viewModel.serviceState
                    .filter { $0.type == .error }
                    .map { $0.info as? Error }
                    .unwrap()
                    .drive { [handle] error in
                        self.view.removeLoading()
                        handle(error)
                    }
                    .disposed(by: disposeBag)
        
        viewModel.repos.asObservable().bind { repos in
            print(repos)
        }
    }
    
    private func handle(error: Error) {
        let reload: (GGAlertAction) -> Void = { [weak self] _ in
                self?.viewModel
                .viewDidLoad
                .onNext(true)
        }

        let tryAgain = "Try again"

        if let listError = error as? GitHubServiceError {
            displayWarningInView(title: "oh no, an error occurred", message: listError.localizedDescription, buttonTitle: tryAgain, action: reload)
        } else {
            displayWarningInView(title: "Error", message: "An unexpected error occurred", buttonTitle: tryAgain, action: reload)
        }
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
