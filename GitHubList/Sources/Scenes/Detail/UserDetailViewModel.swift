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
    // MARK: - Inputs
    var didTapBack: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<UserDetailViewModel.Route>> { get }
}

final class UserDetailViewModel: UserDetailViewModelProtocol {
    
    // MARK: - Definitions
    typealias DetailNavigation = Navigation<Route>
    
    // MARK: - Inputs
    private(set) var didTapBack: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    private(set) var navigation: Driver<DetailNavigation> = .never()
    
    init() {
        self.navigation = createNavigation()
    }
    
    // Helpers
    // MARK: - Route
    enum Route: Equatable {
        case back
        case openRepository
    }
    
    // MARK: -Internal methods
    private func createNavigation() -> Driver<DetailNavigation> {

        let routeToBack = didTapBack
            .map { DetailNavigation(type: .back, info: $0) }
           
        return Observable.merge([routeToBack])
               .asDriver(onErrorRecover: { _ in .never() })
    }
    
}
