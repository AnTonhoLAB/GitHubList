//
//  MainListServiceMock.swift
//  GitHubListTests
//
//  Created by George Gomes on 02/07/23.
//

@testable import GitHubList
import Foundation
import RxSwift

class ListServiceMock: MainListServiceProtocol {
    
    private let userA = UserListModel(login: "Vand", id: 1, nodeID: "10", avatarURL: "https://avatar", gravatarID: "https://gravatarID", url: "https://url", htmlURL: "https://htmlURL", followersURL: "https://followersURL", followingURL: "https://followingURL", gistsURL: "https://gistsURL", starredURL: "https://starredURL", subscriptionsURL: "https://subscriptionsURL", organizationsURL: "https://organizationsURL", reposURL: "https://reposURL", eventsURL: "https://eventsURL", receivedEventsURL: "https://receivedEventsURL", type: .user, siteAdmin: true)
    
    private let userB = UserListModel(login: "Lond", id: 2, nodeID: "20", avatarURL: "https://avatar2", gravatarID: "https://gravatarID2", url: "https://url2", htmlURL: "https://htmlURL2", followersURL: "https://followersURL2", followingURL: "https://followingURL2", gistsURL: "https://gistsURL2", starredURL: "https://starredURL2", subscriptionsURL: "https://subscriptionsURL2", organizationsURL: "https://organizationsURL2", reposURL: "https://reposURL2", eventsURL: "https://eventsURL2", receivedEventsURL: "https://receivedEventsURL2", type: .user, siteAdmin: true)
    
    private lazy var users = [self.userA, self.userB]
    
    func fetchInitialList() -> RxSwift.Single<[GitHubList.UserListModel]> {
        return Single<[UserListModel]>
                    .create { single in
                        single(.success(self.users))
                        return Disposables.create()
                    }
    }
    
    func fetchUserImage(from imageURL: String) -> RxSwift.Single<Data> {
        return Single<Data>
                    .create { single in
                        let data = UIImage(systemName: "square.and.arrow.up")!.pngData()!
                        single(.success(data))
                        return Disposables.create()
                    }
    }
    
    func fetchUserFollowes(from user: String) -> RxSwift.Single<[GitHubList.UserListModel]> {
        return Single<[UserListModel]>
                    .create { single in
                        single(.success(self.users))
                        return Disposables.create()
                    }
    }
    
    func fetchUserFollowing(from user: String) -> RxSwift.Single<[GitHubList.UserListModel]> {
        return Single<[UserListModel]>
                    .create { single in
                        single(.success(self.users))
                        return Disposables.create()
                    }
    }
}

class ListServiceErrorMock: MainListServiceProtocol {
    
    func fetchInitialList() -> RxSwift.Single<[GitHubList.UserListModel]> {
        return Single<[UserListModel]>
                    .create { single in
                        single(.failure(GitHubServiceError.internalError))
                        return Disposables.create()
                    }
    }
    
    func fetchUserImage(from imageURL: String) -> RxSwift.Single<Data> {
        return Single<Data>
                    .create { single in
                        single(.failure(GitHubServiceError.internalError))
                        return Disposables.create()
                    }
    }
    
    func fetchUserFollowes(from user: String) -> RxSwift.Single<[GitHubList.UserListModel]> {
        return Single<[UserListModel]>
                    .create { single in
                        single(.failure(GitHubServiceError.internalError))
                        return Disposables.create()
                    }
    }
    
    func fetchUserFollowing(from user: String) -> RxSwift.Single<[GitHubList.UserListModel]> {
        return Single<[UserListModel]>
                    .create { single in
                        single(.failure(GitHubServiceError.internalError))
                        return Disposables.create()
                    }
    }
}
