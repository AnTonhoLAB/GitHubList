//
//  SearchViewModel.swift
//  GitHubList
//
//  Created by George Gomes on 02/07/23.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit


protocol SearchViewModelProtocol {
    // MARK: - Inputs
    var didTapBack: PublishSubject<Void> { get }
    var nameToSearch: PublishSubject<String> { get }
    var didTapToSearch: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<SearchViewModel.Route>> { get }
}

class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Definitions
    typealias SearchNavigation = Navigation<Route>
    
    // MARK: - Inputs
    private(set) var didTapBack: PublishSubject<Void> = .init()
    private(set) var nameToSearch: PublishSubject<String> = .init()
    private(set) var didTapToSearch: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    private(set) var navigation: Driver<SearchNavigation> = .never()
    
    init() {
        self.navigation = createNavigation()
    }
    
    private func createNavigation() -> Driver<SearchNavigation> {
        
        let routeToDetail = didTapToSearch.withLatestFrom(nameToSearch)
            .map {  SearchNavigation(type: .searchUser, info: SimpleUser(login: $0))}
            .asObservable()

        let routeToBack = didTapBack
            .map { SearchNavigation(type: .back, info: $0) }
           
        return Observable.merge([routeToBack, routeToDetail])
               .asDriver(onErrorRecover: { _ in .never() })
    }
}

// MARK: - Helpers
extension SearchViewModel {
    
    // MARK: - Route
    enum Route: Equatable {
        case back
        case searchUser
    }
}
