//
//  MainListViewController.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import UIKit
import RxSwift
import RxCocoa
import GGDevelopmentKit

class MainListViewController: UIViewController, GGAlertableViewController {
    
    private var viewModel: MainListViewModelProtocol
    let disposeBag = DisposeBag()
    
    lazy var listTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
        return $0
    }(UITableView(frame: .zero))
    
    // MARK: - Initializers
    init(viewModel: MainListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupRX()
    
        viewModel.viewDidLoad
                    .onNext(true)
    }
    
    func setupRX() {
        
        viewModel.userList.asObservable()
            .bind(to: listTableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)){ (row, user, cell) in
                cell.setup(with: user)
            }
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

extension MainListViewController: ViewCoded {
    func setupViews() {
        view.addSubview(listTableView)
    }
    
    func setupViewConfigs() {
    }
    
    func setupConstraints() {
        
        listTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        listTableView.translatesAutoresizingMaskIntoConstraints = false
    }
}
