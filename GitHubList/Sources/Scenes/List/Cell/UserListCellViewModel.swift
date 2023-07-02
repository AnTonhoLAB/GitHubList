//
//  UserListCellViewModel.swift
//  GitHubList
//
//  Created by George Gomes on 01/07/23.
//

import Foundation
import RxSwift

protocol UserListCellViewModelProtocol {
    var nickName: String { get }
    
    // MARK: - Inputs
    var startLoad: PublishSubject<Bool> { get }
    
    // MARK: - Outputs
    var userImage: Observable<Data> { get }
    var followersCount: Observable<Int> { get }
    var followingCount: Observable<Int> { get }
}

class UserListCellViewModel: UserListCellViewModelProtocol {
    
    private let userModel: UserListModel
    
    private let userImageResponse = PublishSubject<Data>()
    private let followersResponse = PublishSubject<Int>()
    private let followingResponse = PublishSubject<Int>()
    
    // MARK: - Inputs
    let startLoad: PublishSubject<Bool> = .init()
    
    // MARK: - Outputs
    let nickName: String
    private(set) var userImage: Observable<Data>
    private(set) var followersCount: Observable<Int>
    private(set) var followingCount: Observable<Int>
    
    // MARK: - Initializers 
    init(userModel: UserListModel, service: MainListServiceProtocol) {
        self.userModel = userModel
        self.nickName = userModel.login
        
        self.userImage = userImageResponse.asObservable()
        self.followersCount = followersResponse.asObservable()
        self.followingCount = followersResponse.asObservable()

        let _ = service.fetchUserImage(from: userModel.avatarURL)
            .asObservable()
            .subscribe { [userImageResponse] data in
                userImageResponse.onNext(data)
            }
        
        let _ = service.fetchUserFollowes(from: userModel.login)
            .asObservable()
            .subscribe { [followersResponse] followers in
                followersResponse.onNext(followers.count)
            }
        
        let _ = service.fetchUserFollowing(from: userModel.login)
            .asObservable()
            .subscribe { [followersResponse] followers in
                followersResponse.onNext(followers.count)
            }
    }
}
