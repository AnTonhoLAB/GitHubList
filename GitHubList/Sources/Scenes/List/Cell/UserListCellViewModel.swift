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
    
    // Imputs
    var startLoad: PublishSubject<Bool> { get }
    
    // Outputs
    var userImage: Observable<Data> { get }
}

class UserListCellViewModel: UserListCellViewModelProtocol {
    
    private let userModel: UserListModel
    
    private let userImageResponse = PublishSubject<Data>()
    
    // Imputs
    let startLoad: PublishSubject<Bool> = .init()
    
    // Outputs
    let nickName: String
    private(set) var userImage: Observable<Data>
    
    init(userModel: UserListModel, service: MainListServiceProtocol) {
        self.userModel = userModel
        self.nickName = userModel.login
        
        self.userImage = userImageResponse.asObservable()

        let _ = service.fetchUserImage(from: userModel.avatarURL)
            .asObservable()
            .subscribe { data in
                self.userImageResponse.onNext(data)
            }
    }
}
