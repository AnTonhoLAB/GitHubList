//
//  UserDetailViewModel.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit


protocol UserDetailViewModelProtocol {
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<UserDetailViewModel.Route>> { get }
}

final class UserDetailViewModel: UserDetailViewModelProtocol {
    
    // MARK: - Definitions
    typealias ListNavigation = Navigation<Route>
    
    // MARK: - Outputs
    private(set) var navigation: Driver<ListNavigation> = .never()
    
    // Helpers
    // MARK: - Route
    enum Route: Equatable {
        case openRepository
    }
    
}
