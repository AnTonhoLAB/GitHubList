//
//  SearchUserViewController.swift
//  GitHubList
//
//  Created by George Gomes on 02/07/23.
//

import UIKit
import GGDevelopmentKit
import RxSwift
import RxCocoa


class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModelProtocol
    let disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    private let searchBar: UISearchBar = UISearchBar()
    
    // MARK: - Initializers
    init(viewModel: SearchViewModelProtocol) {
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
        
        searchBar.rx
            .text
            .orEmpty
            .bind(to: viewModel.nameToSearch)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.didTapToSearch)
            .disposed(by: disposeBag)
        
    }
}

extension SearchViewController: ViewCoded {
    func setupViews() {
        
        view.addSubview(searchBar)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViewConfigs() {
        self.view.backgroundColor = .white
        
    }
    
    func setupConstraints() {
        
        searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
