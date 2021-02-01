//
//  UsersViewModel.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import Foundation
import RxSwift
import RxRelay


class UsersViewModel {
    
    //MARK: - rx Observables
    let datasource : BehaviorRelay<[User]> = BehaviorRelay(value: [])
    let webServiceStatus : BehaviorRelay<WebserviceStatus> = BehaviorRelay(value: .none)
    
    //MARK: - Local variables
    private let servicesClient = AlbumsServicesClient()
    private var allUsers = [User]()
    private let disposeBag = DisposeBag()
    
    //MARK: - Public methods
    func getAllUsers() {
        //Check for cached users
        if let cachedUsers = CacheManager.getCachedUsers() {
            //If there are already users displyed, abort
            if datasource.value.count > 0 {
                return
            }
            self.allUsers = cachedUsers
            self.datasource.accept(cachedUsers)
            return
        }
        webServiceStatus.accept(.loading)
        servicesClient.getUsers()
            .subscribe(
                onNext: { [weak self] users in
                    guard let self = self else { return }
                    self.allUsers = users
                    CacheManager.cacheUsers(users: users)
                    self.datasource.accept(users)
                    self.webServiceStatus.accept(.success)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    print(error)
                    self.webServiceStatus.accept(.failed)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getSearchPlaceHolder(scope: Int) -> String {
        switch scope {
        case 0:
            return SearchPlaceholders.name.rawValue
        case 1:
            return SearchPlaceholders.username.rawValue
        case 2:
            return SearchPlaceholders.email.rawValue
        case 3:
            return SearchPlaceholders.phone.rawValue
        case 4:
            return SearchPlaceholders.website.rawValue
        default:
            return SearchPlaceholders.name.rawValue
        }
    }
    
    func search(query:String, selectedScope: Int) {
        guard !query.isEmpty, !allUsers.isEmpty else {
            self.datasource.accept(allUsers);
            return
        }
        var searchResults = [User]()
        switch selectedScope {
        case 0:
            searchResults = allUsers.filter({$0.name.lowercased().contains(query.lowercased())})
        case 1:
            searchResults = allUsers.filter({$0.username.lowercased().contains(query.lowercased())})
        case 2:
            searchResults = allUsers.filter({($0.email?.lowercased().contains(query.lowercased()) ?? false)})
        case 3:
            searchResults = allUsers.filter({($0.phone?.lowercased().contains(query.lowercased()) ?? false)})
        case 4:
            searchResults = allUsers.filter({$0.website?.lowercased().contains(query.lowercased()) ?? false})
        default:
            searchResults = allUsers.filter({$0.name.lowercased().contains(query.lowercased())})
        }
        datasource.accept(searchResults)
    }
}
