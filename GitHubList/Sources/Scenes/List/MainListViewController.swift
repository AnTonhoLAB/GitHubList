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
    
    lazy var mainView = UIView()
    
    // MARK: - Initializers
    init(viewModel: MainListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        setupLayout()
    }
}

extension MainListViewController: ViewCoded {
    func setupViews() {
        view.addSubview(mainView)
    }
    
    func setupViewConfigs() {
        mainView.backgroundColor = .red
    }
    
    func setupConstraints() {
        
        mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainView.translatesAutoresizingMaskIntoConstraints = false
    }
}
