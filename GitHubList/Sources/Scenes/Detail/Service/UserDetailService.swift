//
//  UserDetailService.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import RxSwift

protocol UserDetailServiceProtocol {
    func fetchDetail(for user: String) -> Single<UserDetail>
    func fetchRepos(for user: String) -> Single<[RepoListElement]>
    func fetchUserImage(from imageURL: String) -> Single<Data>
    func fetchUserFollowes(from user: String) -> Single<[UserListModel]>
    func fetchUserFollowing(from user: String) -> Single<[UserListModel]>
}

final class UserDetailService: UserDetailServiceProtocol, RequesterProtocol {

    private let baseURL = "https://api.github.com/users/"
    private let networkingManager: NetworkingManagerProtocol
    
    init(networkingManager: NetworkingManagerProtocol) {
        self.networkingManager = networkingManager
    }
    
    func fetchDetail(for user: String) -> Single<UserDetail> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return GitHUBServiceErrorRX.NoConnection.noConectionRXSingle
        }
        
        // If internet is ok
        return Single<UserDetail>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL + user, single: single)
                return Disposables.create()
            }
    }
    
    func fetchRepos(for user: String) -> Single<[RepoListElement]> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return GitHUBServiceErrorRX.NoConnection.noConectionRXSingle
        }
        
        // If internet is ok
        return Single<[RepoListElement]>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL + user + "/repos", single: single)
                return Disposables.create()
            }
    }
    
    
    func fetchUserImage(from imageURL: String) -> Single<Data> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return GitHUBServiceErrorRX.NoConnection.noConectionRXSingle
        }
        
        // If internet is ok
        return Single<Data>
            .create { [weak self] single in
                self?.makeRequestForImage(url: imageURL, single: single)
                return Disposables.create()
            }
    }
    
    func fetchUserFollowes(from user: String) -> Single<[UserListModel]> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return GitHUBServiceErrorRX.NoConnection.noConectionRXSingle
        }
        
        // If internet is ok
        return Single<[UserListModel]>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL + "/\(user)/followers", single: single)
                return Disposables.create()
            }
    }
    
    func fetchUserFollowing(from user: String) -> Single<[UserListModel]> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return GitHUBServiceErrorRX.NoConnection.noConectionRXSingle
        }
        
        // If internet is ok
        return Single<[UserListModel]>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL + "/\(user)/following", single: single)
                return Disposables.create()
            }
    }
}
