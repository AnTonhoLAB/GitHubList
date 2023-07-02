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
    
    // MARK: - Views
    private(set) lazy var backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    private(set) var userImage = UIImageView()
    private(set) var nickNameLabel: UILabel = UILabel()
    private(set) var nameLabel: UILabel = UILabel()
    private(set) var followersLabel: UILabel = UILabel()
    private(set) var followingLabel: UILabel = UILabel()
    private(set) var emailLabel: UILabel = UILabel()
    private(set) var blogLabel: UILabel = UILabel()
    private(set) var locationLabel: UILabel = UILabel()
    
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
        
        viewModel.userImage
            .asObservable()
            .bind(to: userImage.rx.imageData)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { $0.login }
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { $0.email }
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { $0.location }
            .bind(to: locationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { $0.blog }
            .bind(to: blogLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { "\($0.followers) \n seguidores"}
            .bind(to: followersLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userDetail
            .map { "\($0.following) \n seguindo"}
            .bind(to: followingLabel.rx.text)
            .disposed(by: disposeBag)
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
//        view.addSubview(mainView)
        
        view.addSubview(userImage)
        view.addSubview(nickNameLabel)
        view.addSubview(nameLabel)
        view.addSubview(followersLabel)
        view.addSubview(followingLabel)
        view.addSubview(emailLabel)
        view.addSubview(blogLabel)
        view.addSubview(locationLabel)
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViewConfigs() {
        self.view.backgroundColor = .white
    }
    
    func setupConstraints() {
        
        userImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
    }
}
