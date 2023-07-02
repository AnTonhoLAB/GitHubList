//
//  RepoListCell.swift
//  GitHubList
//
//  Created by George Gomes on 02/07/23.
//

import UIKit
import GGDevelopmentKit

class RepoListCell: UITableViewCell {
    
    // MARK: - Static variables
    static let identifier = "RepoListCell"
    
    private let nameLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    
    private let languageImage: UIImageView = UIImageView(image: UIImage(systemName: "macbook.and.ipad"))
    private let starImage: UIImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    private let forkImage: UIImageView = UIImageView(image:UIImage(systemName: "tuningfork"))
    private let eyeImage: UIImageView = UIImageView(image: UIImage(systemName: "eye.circle"))
    
    private let languageNameLabel: UILabel = UILabel()
    private let starCountLabel: UILabel = UILabel()
    private let forkCountLabel: UILabel = UILabel()
    private let eyeCountLabel: UILabel = UILabel()
    
    private lazy var languageStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [self.languageImage, self.languageNameLabel]))
    
    private lazy var starStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [self.starImage, self.starCountLabel]))
    
    private lazy var forkStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [self.forkImage, self.forkCountLabel]))
    
    private lazy var eyeStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [self.eyeImage, self.eyeCountLabel]))
    
    private lazy var statsStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [self.starStack, self.forkStack, self.eyeStack]))
    
    
    
    // MARK: - Public methods
    func setup(with repo: RepoListElement) {
        self.nameLabel.text = repo.name
        self.descriptionLabel.text = repo.description
        
        languageNameLabel.text = repo.language
        starCountLabel.text = "\(repo.stargazersCount)"
        forkCountLabel.text = "\(repo.forksCount)"
        eyeCountLabel.text = "\(repo.watchers)"
        
        self.selectionStyle = .none
        setupLayout()
        
    }
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
    }
}

extension RepoListCell: ViewCoded {
    
    internal func setupViews() {
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(languageStack)
        self.contentView.addSubview(statsStack)
    }
    
    internal func setupViewConfigs() {
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .darkText
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = descriptionLabel.font.withSize(12)
        descriptionLabel.textColor = .darkText
        descriptionLabel.numberOfLines = 2
        
        languageNameLabel.font = languageNameLabel.font.withSize(14)
        
        starCountLabel.font = starCountLabel.font.withSize(12)
        
        forkCountLabel.font = forkCountLabel.font.withSize(12)
        
        eyeCountLabel.font = eyeCountLabel.font.withSize(12)
    }
    
    internal func setupConstraints() {
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        languageImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        languageImage.translatesAutoresizingMaskIntoConstraints = false
        
        languageStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        languageStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        languageStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        languageStack.widthAnchor.constraint(equalToConstant: 120).isActive = true
        languageStack.translatesAutoresizingMaskIntoConstraints = false
        
        statsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        statsStack.leadingAnchor.constraint(equalTo: languageStack.trailingAnchor, constant: 5).isActive = true
        statsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
        statsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        statsStack.translatesAutoresizingMaskIntoConstraints = false
    }
}
