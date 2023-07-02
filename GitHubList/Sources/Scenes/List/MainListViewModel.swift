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
    
    private let service: MainListService
    private let userListResponse = PublishSubject<[UserListModel]>()
    
    // MARK: - Inputs
    let viewDidLoad: PublishSubject<Bool> = .init()
    let didSelectItem: PublishSubject<UserListModel> = .init()
    
    // MARK: - Outputs
    private(set) var userList: Driver<[UserListModel]> = .never()
    private(set) var navigation: Driver<ListNavigation> = .never()
    private(set) var serviceState: Driver<ServiceState> = .never()
    
    init(service: MainListService) {
        self.service = service
        self.serviceState = createServiceState()
        
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
