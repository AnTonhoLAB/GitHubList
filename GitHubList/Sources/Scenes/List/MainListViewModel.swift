//
//  MainListViewModel.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit

protocol MainListViewModelProtocol {
    
    // MARK: - Inputs
    var viewDidLoad: PublishSubject<Bool> { get }
    var didSelectItem: PublishSubject<UserListModel> { get }
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<MainListViewModel.Route>> { get }
    var serviceState: Driver<Navigation<MainListViewModel.State>> { get }
    var userList: Driver<[UserListModel]> { get }
}

final class MainListViewModel: MainListViewModelProtocol {
    
    // MARK: - Definitions
    typealias ListNavigation = Navigation<Route>
    typealias ServiceState = Navigation<State>
    
    private let service: MainListServiceProtocol
    private let userListResponse = PublishSubject<[UserListModel]>()
    
    // MARK: - Inputs
    private(set) var viewDidLoad: PublishSubject<Bool> = .init()
    private(set) var didSelectItem: PublishSubject<UserListModel> = .init()
    
    // MARK: - Outputs
    private(set) var userList: Driver<[UserListModel]> = .never()
    private(set) var navigation: Driver<ListNavigation> = .never()
    private(set) var serviceState: Driver<ServiceState> = .never()
    
    init(service: MainListServiceProtocol) {
        self.service = service
        self.serviceState = createServiceState()
        self.navigation = createNavigation()
        
        self.userList = userListResponse.asDriverOnErrorJustComplete()
    }
    
    // MARK: - Internal methods
    private func createServiceState() -> Driver<ServiceState> {
                
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetchList: (() -> Observable<MainListViewModel.ServiceState>) = { [userListResponse, service]  in
            return service.fetchInitialList()
                        .trackActivity(activityIndicator)
                        .do(onNext: { [userListResponse] res in
                            userListResponse.onNext(res)
                        })
                        .map {
                            ServiceState(type: .success, info: $0)
                        }
                        .catch { err in
                            return .just(ServiceState(type: .error, info: err))
                        }
        }
       
        let loadList = viewDidLoad
            .flatMapLatest { reload in
                fetchList()
            }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        let errorToShow = errorTracker
            .map { ServiceState(type: .error, info: $0)}
            .asObservable()
        
        return Observable
            .merge(loadList, loadingShown, errorToShow)
            .asDriverOnErrorJustComplete()
        }
}

extension MainListViewModel {
    // MARK: -Internal methods
    private func createNavigation() -> Driver<ListNavigation> {

        let routeToNext = didSelectItem
            .map { ListNavigation(type: .openDetail, info: $0) }
        
        return Observable.merge([routeToNext])
            .asDriver(onErrorRecover: { _ in .never() })
    }
}

// MARK: - Helpers
extension MainListViewModel {
    
    // MARK: - Route
    enum Route: Equatable {
        case openDetail
    }
    
    // MARK: - State
    enum State: Equatable {
        case loading
        case success
        case error
    }
}
