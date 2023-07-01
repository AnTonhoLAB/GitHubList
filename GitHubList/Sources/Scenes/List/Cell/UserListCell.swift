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
    
    // MARK: - Public properties
    private(set) var nameLabel: UILabel = UILabel(frame: .zero)
        
    // MARK: - Public methods
    func setup(with user: UserListModel) {
        self.nameLabel.text = user.login
        
        setupLayout()
    }
    
    // MARK: - Private methods
    
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.backgroundColor = .clear
//        self.imageBG.tintColor = .white
//        self.pokemonImage.image = nil
//        self.nameLabel.text = ""
//        self.numberLabel.text = ""
//        disposeBag = DisposeBag()
//    }
}

extension UserListCell: ViewCoded {
    
    internal func setupViews() {
        self.contentView.addSubview(nameLabel)
    }
    
    internal func setupViewConfigs() {
        
    }
    
    internal func setupConstraints() {
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
