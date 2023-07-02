//
//  UserListCell.swift
//  GitHubList
//
//  Created by George Gomes on 01/07/23.
//
import UIKit
import RxSwift
import GGDevelopmentKit

class UserListCell: UITableViewCell {
    
    // MARK: - Static variables
    static let identifier = "UserListCell"
    
    // MARK: - Private properties
    private let font = UIFont(name: "GillSans-Bold", size: 17)
    private var disposeBag = DisposeBag()
    
    private(set) var nameLabel: UILabel = UILabel()
    private(set) lazy var userImage = UIImageView()
    
    // MARK: - Public methods
    func setup(with viewModel: UserListCellViewModelProtocol) {
        self.nameLabel.text = viewModel.nickName
        
        setupLayout()
        setupRX(with: viewModel)
    }
    
    func setupRX(with viewModel: UserListCellViewModelProtocol) {
        viewModel.userImage
            .bind(to: userImage.rx.imageData)
            .disposed(by: disposeBag)
        
        viewModel.startLoad.onNext(true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViewConfigs()
        self.userImage.image = nil
        self.nameLabel.text = nil
        
        disposeBag = DisposeBag()
    }
}

extension UserListCell: ViewCoded {
    
    internal func setupViews() {
        
        self.contentView.addSubview(userImage)
        self.contentView.addSubview(nameLabel)
    
    }
    
    internal func setupViewConfigs() {
    }
    
    internal func setupConstraints() {
        
        userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor).isActive = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
