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
    private var disposeBag = DisposeBag()
    
    private(set) lazy var userImage = UIImageView()
    private(set) var nameLabel: UILabel = UILabel()
    private(set) var followersLabel: UILabel = UILabel()
    private(set) var followingLabel: UILabel = UILabel()
    private lazy var counterStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        return $0
    }(UIStackView(arrangedSubviews: [self.followersLabel, self.followingLabel]))
    
    // MARK: - Public methods
    func setup(with viewModel: UserListCellViewModelProtocol) {
        self.nameLabel.text = viewModel.nickName
        self.selectionStyle = .none
        setupLayout()
        setupRX(with: viewModel)
    }
    
    // MARK: - Private methods
    private func setupRX(with viewModel: UserListCellViewModelProtocol) {
        viewModel.userImage
            .bind(to: userImage.rx.imageData)
            .disposed(by: disposeBag)
        
        viewModel.followersCount
            .map { "\($0) \n seguidores"}
            .bind(to: followersLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.followingCount
            .map { "\($0) \n seguindo"}
            .bind(to: followingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.startLoad.onNext(true)
    }
    
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViewConfigs()
        self.userImage.image = nil
        self.nameLabel.text = nil
        self.followersLabel.text = nil
        self.followingLabel.text = nil
        
        disposeBag = DisposeBag()
    }
}

extension UserListCell: ViewCoded {
    
    internal func setupViews() {
        
        self.contentView.addSubview(userImage)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(counterStackView)
    }
    
    internal func setupViewConfigs() {
        nameLabel.textAlignment = .center
        
        followingLabel.font = followingLabel.font.withSize(14)
        followingLabel.textAlignment = .center
        followingLabel.numberOfLines = 2
        
        followersLabel.font = followersLabel.font.withSize(14)
        followersLabel.textAlignment = .center
        followersLabel.numberOfLines = 2
    }
    
    internal func setupConstraints() {
        
        userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor).isActive = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        counterStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        counterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        counterStackView.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10).isActive = true
        counterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        counterStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
