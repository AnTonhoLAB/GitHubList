//
//  ListAllViewModelTests.swift
//  GitHubListTests
//
//  Created by George Gomes on 02/07/23.
//

import Quick
import Nimble
import RxTest
import RxSwift
import GGDevelopmentKit

@testable import GitHubList

class ListAllViewModelTests: QuickSpec {
    
    private var sut: MainListViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    func setUpTests() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func spec() {
        tests()
    }
    
    private func tests() {
        
        describe("View model que faz a chamada de listagem dos usuarios") {
            
            context("Quando o usuario abre a tela e a listagem é chamada com sucesso") {
                
                afterEach {
                    self.sut = nil
                }
                
                beforeEach {
                    self.setUpTests()
                    self.sut = MainListViewModel(service: ListServiceMock())
                    
                    self.scheduler.createColdObservable([.next(10, (true)),
                                                         .next(20, (true))])
                    .bind(to: self.sut.viewDidLoad)
                    .disposed(by: self.disposeBag)
                }
                
                it("Então o estatus fica loading e depois sucesso") {
                    let state = self.scheduler.createObserver(Navigation<MainListViewModel.State>.self)
                    
                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    
                    let stateLoading : Navigation<MainListViewModel.State> = Navigation(type: .loading)
                    let stateSuccess : Navigation<MainListViewModel.State> = Navigation(type: .success)
                    
                    expect(state.events).to(equal([.next(10, stateLoading),
                                                   .next(10, stateSuccess),
                                                   .next(20, stateLoading),
                                                   .next(20, stateSuccess)
                    ]))
                }
                
                it("Então a lista é preenchida") {
                    let userList = self.scheduler.createObserver([UserListModel].self)
                    let state = self.scheduler.createObserver(Navigation<MainListViewModel.State>.self)
                    
                    self.sut.userList
                        .drive(userList)
                        .disposed(by: self.disposeBag)

                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)

                    self.scheduler.start()

                    let userA = UserListModel(login: "Vand", id: 1, nodeID: "10", avatarURL: "https://avatar", gravatarID: "https://gravatarID", url: "https://url", htmlURL: "https://htmlURL", followersURL: "https://followersURL", followingURL: "https://followingURL", gistsURL: "https://gistsURL", starredURL: "https://starredURL", subscriptionsURL: "https://subscriptionsURL", organizationsURL: "https://organizationsURL", reposURL: "https://reposURL", eventsURL: "https://eventsURL", receivedEventsURL: "https://receivedEventsURL", type: .user, siteAdmin: true)

                    let userB = UserListModel(login: "Lond", id: 2, nodeID: "20", avatarURL: "https://avatar2", gravatarID: "https://gravatarID2", url: "https://url2", htmlURL: "https://htmlURL2", followersURL: "https://followersURL2", followingURL: "https://followingURL2", gistsURL: "https://gistsURL2", starredURL: "https://starredURL2", subscriptionsURL: "https://subscriptionsURL2", organizationsURL: "https://organizationsURL2", reposURL: "https://reposURL2", eventsURL: "https://eventsURL2", receivedEventsURL: "https://receivedEventsURL2", type: .user, siteAdmin: true)

                    let users = [userA, userB]


                    expect(userList.events).to(equal(
                        [
                            .next(10, users),
                            .next(20,users)
                        ]
                    ))
                }
            }
                
            context("Quando o usuario abre a tela e a listagem é chamada com erro") {
                    
                afterEach {
                    self.sut = nil
                }
                    
                beforeEach {
                    self.setUpTests()
                    self.sut = MainListViewModel(service: ListServiceErrorMock())

                    self.scheduler.createColdObservable([.next(10, (true))])
                                                .bind(to: self.sut.viewDidLoad)
                                                .disposed(by: self.disposeBag)
                }
                    
                it("Então o estatus fica loading e depois error") {
                    let state = self.scheduler.createObserver(Navigation<MainListViewModel.State>.self)
                    
                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)
                        
                        self.scheduler.start()
    
                        let stateLoading : Navigation<MainListViewModel.State> = Navigation(type: .loading)
                        let stateError : Navigation<MainListViewModel.State> = Navigation(type: .error)
    
                        expect(state.events).to(equal([.next(10, stateLoading),
                                                       .next(10, stateError)]))
                }
                    
                it("Então a lista fica vazia") {
                    let userList = self.scheduler.createObserver([UserListModel].self)
                    let state = self.scheduler.createObserver(Navigation<MainListViewModel.State>.self)

                    self.sut.userList
                        .drive(userList)
                        .disposed(by: self.disposeBag)

                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)

                    self.scheduler.start()

                    expect(userList.events).to(equal([]))
                }
            }
        }
    }
}
