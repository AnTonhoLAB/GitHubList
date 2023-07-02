//
//  MainListService.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import RxSwift

protocol MainListServiceProtocol {
    func fetchInitialList() -> Single<[UserListModel]>
    func fetchUserImage(from imageURL: String) -> Single<Data>
}

final class MainListService: MainListServiceProtocol, RequesterProtocol {

    private let baseURL = "https://api.github.com/users"
    private let networkingManager: NetworkingManagerProtocol
    
    init(networkingManager: NetworkingManagerProtocol) {
        self.networkingManager = networkingManager
    }
    
    func fetchInitialList() -> Single<[UserListModel]> {
        // Check internet
        guard networkingManager.isConnected()  else {
            // If there is no connection return error
            return GitHUBServiceErrorRX.NoConnection.noConectionRXSingle
        }
        
        // If internet is ok
        return Single<[UserListModel]>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL, single: single)
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
    
}
