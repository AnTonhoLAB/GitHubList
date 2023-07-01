//
//  MainListService.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import RxSwift

protocol MainListDetailServiceProtocol {
    func fetchInitialList() -> Single<[UserListModel]>
}

final class MainListDetailService: MainListDetailServiceProtocol, RequesterProtocol {

    private let baseURL = "https://api.github.com/users"
    private let networkingManager: NetworkingManagerProtocol
    
    init(networkingManager: NetworkingManagerProtocol) {
        self.networkingManager = networkingManager
    }
    
    func fetchInitialList() -> Single<[UserListModel]> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return Single<[UserListModel]>
                        .create { single in
                            single(.failure(GitHubServiceError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        // If internet is ok
        return Single<[UserListModel]>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL, single: single)
                return Disposables.create()
            }
    }
    
    
}
