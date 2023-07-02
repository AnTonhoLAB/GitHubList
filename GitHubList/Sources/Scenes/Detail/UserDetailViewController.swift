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
    private lazy var backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    private let userImage = UIImageView()
    private let nickNameLabel: UILabel = UILabel()
    private let nameLabel: UILabel = UILabel()
    private let reposLabel: UILabel = UILabel()
    private let followersLabel: UILabel = UILabel()
    private let followingLabel: UILabel = UILabel()
    private lazy var counterStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        return $0
    }(UIStackView(arrangedSubviews: [self.reposLabel, self.followersLabel, self.followingLabel]))
    private let emailLabel: UILabel = UILabel()
    private let blogLabel: UILabel = UILabel()
    private lazy var contactStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        return $0
    }(UIStackView(arrangedSubviews: [self.emailLabel, self.blogLabel]))
    private let locationLabel: UILabel = UILabel()
    private lazy var basicInfo: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        return $0
    }(UIStackView(arrangedSubviews: [self.nameLabel, self.locationLabel]))
    lazy var reposTableView: UITableView = {
        $0.register(RepoListCell.self, forCellReuseIdentifier: RepoListCell.identifier)
        $0.rowHeight = 100
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView(frame: .zero))
    
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
        
        viewModel.repos.asObservable()
            .map { "\($0.count) \n repos"}
            .bind(to: reposLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.repos.asObservable()
            .bind(to: reposTableView.rx.items(cellIdentifier: RepoListCell.identifier, cellType: RepoListCell.self)){ (row, repo, cell) in
                cell.setup(with: repo)
            }
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
        view.addSubview(userImage)
        view.addSubview(nickNameLabel)
        view.addSubview(counterStackView)
        view.addSubview(contactStackView)
        view.addSubview(basicInfo)
        view.addSubview(reposTableView)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViewConfigs() {
        self.view.backgroundColor = .white
        
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nickNameLabel.textColor = .darkText
        nickNameLabel.textAlignment = .center
        nickNameLabel.font = nickNameLabel.font.withSize(22)
        
        reposLabel.numberOfLines = 2
        reposLabel.textAlignment = .center
        reposLabel.font = followingLabel.font.withSize(12)
        
        followersLabel.numberOfLines = 2
        followersLabel.textAlignment = .center
        followersLabel.font = followersLabel.font.withSize(12)

        followingLabel.numberOfLines = 2
        followingLabel.textAlignment = .center
        followingLabel.font = followingLabel.font.withSize(12)
        
        emailLabel.textAlignment = .center
        emailLabel.font = followingLabel.font.withSize(14)
        
        blogLabel.textAlignment = .center
        blogLabel.font = followingLabel.font.withSize(14)
        
        nameLabel.textAlignment = .center
        nameLabel.font = followingLabel.font.withSize(16)
        
        locationLabel.textAlignment = .center
        locationLabel.font = followingLabel.font.withSize(16)
    }
    
    func setupConstraints() {
        
        userImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        nickNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor).isActive = true
        nickNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        nickNameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false

        counterStackView.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor).isActive = true
        counterStackView.leadingAnchor.constraint(equalTo: userImage.trailingAnchor).isActive = true
        counterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        counterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contactStackView.topAnchor.constraint(equalTo: counterStackView.bottomAnchor).isActive = true
        contactStackView.leadingAnchor.constraint(equalTo: userImage.trailingAnchor).isActive = true
        contactStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        
        basicInfo.topAnchor.constraint(equalTo: contactStackView.bottomAnchor).isActive = true
        basicInfo.leadingAnchor.constraint(equalTo: userImage.trailingAnchor).isActive = true
        basicInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        basicInfo.bottomAnchor.constraint(equalTo: userImage.bottomAnchor).isActive = true
        basicInfo.translatesAutoresizingMaskIntoConstraints = false
        
        reposTableView.topAnchor.constraint(equalTo: basicInfo.bottomAnchor, constant: 10).isActive = true
        reposTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reposTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        reposTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        reposTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
