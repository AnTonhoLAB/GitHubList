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
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<MainListViewModel.Route>> { get }
}

final class MainListViewModel: MainListViewModelProtocol {
    
    // MARK: - Definitions
    typealias ListNavigation = Navigation<Route>
    
    // MARK: - Outputs
    private(set) var navigation: Driver<ListNavigation> = .never()
    
    // Helpers
    // MARK: - Route
    enum Route: Equatable {
        case openDetail
    }
    
}
