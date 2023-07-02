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
    var userImage: Observable<Data> { get }
    var userDetail: Observable<UserDetail> { get }
    var repos: Observable<[RepoListElement]> { get }
}

final class UserDetailViewModel: UserDetailViewModelProtocol {
    
    // MARK: - Definitions
    typealias DetailNavigation = Navigation<Route>
    typealias ServiceState = Navigation<State>
    
    private let service: UserDetailServiceProtocol
    private let userResponse = PublishSubject<UserDetail>()
    private let reposResponse = PublishSubject<[RepoListElement]>()
    private let userImageResponse = PublishSubject<Data>()
    
    private let user: SimpleUserProtocol
    
    // MARK: - Inputs
    private(set) var viewDidLoad: PublishSubject<Bool> = .init()
    private(set) var didTapBack: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    private(set) var userImage: Observable<Data>
    private(set) var userDetail: Observable<UserDetail> = .never()
    private(set) var repos: Observable<[RepoListElement]> = .never()
    private(set) var navigation: Driver<DetailNavigation> = .never()
    private(set) var serviceState: Driver<ServiceState> = .never()
    
    init(user: SimpleUserProtocol, service: UserDetailServiceProtocol) {
        self.user = user
        self.service = service
        
        self.userImage = userImageResponse.asObservable()
        self.userDetail = userResponse.asObservable()
        self.repos = reposResponse.asObservable()
        
        self.serviceState = createServiceState()
        self.navigation = createNavigation()
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
        
        let fetchUserImage: ((_ fromURL: String) -> Observable<UserDetailViewModel.ServiceState>) = { [userImageResponse, service] url in
            return service.fetchUserImage(from: url)
                    .trackActivity(activityIndicator)
                    .do(onNext: { [userImageResponse] res in
                        userImageResponse.onNext(res)
                    })
                    .map {
                        ServiceState(type: .success, info: $0)
                    }
                    .catch { err in
                        return .just(ServiceState(type: .error, info: err))
                    }
        }
        
        let loadUserImage = userResponse
            .flatMapLatest { user in
                fetchUserImage(user.avatarURL)
            }
        
        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        let errorToShow = errorTracker
            .map { ServiceState(type: .error, info: $0)}
            .asObservable()
        
        return Observable
            .merge(loadUser, loadUserImage, loadRepos, loadingShown, errorToShow)
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
