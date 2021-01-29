//
//  AlbumsViewModel.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation
import RxSwift
import RxRelay

class AlbumsViewModel {
    
    //MARK: - rx Observables
    let albums : BehaviorRelay<[Album]> = BehaviorRelay(value: [])
    let webServiceStatus : BehaviorRelay<WebserviceStatus> = BehaviorRelay(value: .none)
    
    //MARK: - Local variables
    private let servicesClient = AlbumsServicesClient()
    private let disposeBag = DisposeBag()
    
    //MARK: - Public methods
    func getAlbums(userId: Int) {
        if let cachedAlbums = CacheManager.getCachedAlbums(userId: userId) {
            self.albums.accept(cachedAlbums)
            return
        }
        self.webServiceStatus.accept(.loading)
        servicesClient.getAlbums(userId: userId)
            .subscribe(
                onNext: { [weak self] albums in
                    guard let self = self else { return }
                    self.albums.accept(albums)
                    CacheManager.cacheAlbums(albums: albums, userId: userId)
                    self.webServiceStatus.accept(.success)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.webServiceStatus.accept(.failed)
                }
            )
            .disposed(by: disposeBag)
    }
}
