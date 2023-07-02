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
    var viewDidLoad: PublishSubject<Bool> { get }
    var didTapBack: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<UserDetailViewModel.Route>> { get }
    var serviceState: Driver<Navigation<UserDetailViewModel.State>> { get }
    var userDetail: Driver<UserDetail> { get }
    var repos: Driver<[RepoListElement]> { get }
}

final class UserDetailViewModel: UserDetailViewModelProtocol {
    
    // MARK: - Definitions
    typealias DetailNavigation = Navigation<Route>
    typealias ServiceState = Navigation<State>
    
    private let service: UserDetailServiceProtocol
    private let userResponse = PublishSubject<UserDetail>()
    private let reposResponse = PublishSubject<[RepoListElement]>()
    
    private let user: UserListModel
    
    // MARK: - Inputs
    private(set) var viewDidLoad: PublishSubject<Bool> = .init()
    private(set) var didTapBack: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    private(set) var userDetail: Driver<UserDetail> = .never()
    private(set) var repos: Driver<[RepoListElement]> = .never()
    private(set) var navigation: Driver<DetailNavigation> = .never()
    private(set) var serviceState: Driver<ServiceState> = .never()
    
    init(user: UserListModel, service: UserDetailServiceProtocol) {
        self.user = user
        self.service = service
        
        self.serviceState = createServiceState()
        self.navigation = createNavigation()
        
        
        self.userDetail = userResponse.asDriverOnErrorJustComplete()
        self.repos = reposResponse.asDriverOnErrorJustComplete()
    }
    
    // MARK: - Internal methods
    private func createServiceState() -> Driver<ServiceState> {
                
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetchUser: (() -> Observable<UserDetailViewModel.ServiceState>) = { [user, userResponse, service]  in
            return service.fetchDetail(for: user.login)
                        .trackActivity(activityIndicator)
                        .do(onNext: { [userResponse] res in
                            userResponse.onNext(res)
                        })
                        .map {
                            ServiceState(type: .success, info: $0)
                        }
                        .catch { err in
                            return .just(ServiceState(type: .error, info: err))
                        }
        }
       
        let loadUser = viewDidLoad
            .flatMapLatest { reload in
                fetchUser()
            }
        
        let fetchRepos: (() -> Observable<UserDetailViewModel.ServiceState>) = { [user, reposResponse, service]  in
            return service.fetchRepos(for: user.login)
                        .trackActivity(activityIndicator)
                        .do(onNext: { [reposResponse] res in
                            reposResponse.onNext(res)
                        })
                        .map {
                            ServiceState(type: .success, info: $0)
                        }
                        .catch { err in
                            return .just(ServiceState(type: .error, info: err))
                        }
        }
        
        let loadRepos = viewDidLoad
            .flatMapLatest { reload in
                fetchRepos()
            }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        let errorToShow = errorTracker
            .map { ServiceState(type: .error, info: $0)}
            .asObservable()
        
        return Observable
            .merge(loadUser, loadRepos, loadingShown, errorToShow)
            .asDriverOnErrorJustComplete()
        }
    
    private func createNavigation() -> Driver<DetailNavigation> {

        let routeToBack = didTapBack
            .map { DetailNavigation(type: .back, info: $0) }
           
        return Observable.merge([routeToBack])
               .asDriver(onErrorRecover: { _ in .never() })
    }
}

// MARK: - Helpers
extension UserDetailViewModel {
    
    // MARK: - Route
    enum Route: Equatable {
        case back
        case openRepository
    }
    // MARK: - State
    enum State: Equatable {
        case loading
        case success
        case error
    }
}
