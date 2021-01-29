//
//  AlbumDetailsModelView.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 28/01/2021.
//

import Foundation
import RxSwift
import RxRelay

class AlbumDetailsModelView {
    
    //MARK: - rx Observables
    let albumDetails : BehaviorRelay<[AlbumDetails]> = BehaviorRelay(value: [])
    let webServiceStatus : BehaviorRelay<WebserviceStatus> = BehaviorRelay(value: .none)
    
    //MARK: - Local variables
    private let disposeBag = DisposeBag()
    private let servicesClient = AlbumsServicesClient()
    
    //MARK: - Public methods
    func getAlbumDetails(userId: Int, albumId: Int) {
        if let cachedAlbumDetails = CacheManager.getCachedAlbumDetails(albumId: albumId, userId: userId) {
            self.albumDetails.accept(cachedAlbumDetails)
            return
        }
        self.webServiceStatus.accept(.loading)
        servicesClient.getAlbumDetails(userId: userId, albumId: albumId)
            .subscribe(
                onNext: { [weak self] albumDetails in
                    guard let self = self else { return }
                    CacheManager.cacheAlbumDetails(albumDetails: albumDetails, albumId: albumId, userId: userId)
                    self.albumDetails.accept(albumDetails)
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
