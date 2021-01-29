//
//  AlbumDetailsTableViewCellViewModel.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 28/01/2021.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class AlbumDetailsTableViewCellViewModel {
    
    //MARK: - rx Observables
    let albumDetails : BehaviorRelay<AlbumDetails?> = BehaviorRelay(value: nil)
    let thumbnailImage : BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let image : BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    //MARK: - Local variables
    private let disposeBag = DisposeBag()
    
    //MARK: - Rx Binding
    init() {
        setupBinding()
    }
    
    private func setupBinding() {
        albumDetails.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] albumDetails in
                guard let self = self else { return }
                if let thumbnailURL = albumDetails?.thumbnailUrl {
                    self.downloadThumbnailImage(urlString: thumbnailURL)
                }
                
                if let url = albumDetails?.url {
                    self.downloadMainImage(urlString: url)
                }
            }).disposed(by: disposeBag)

    }
    
    //MARK: - Private methods
    private func downloadThumbnailImage(urlString: String) {
        ImageDownloadServices.shared.downloadImage(urlString: urlString)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (image) in
                guard let self = self else { return }
                self.thumbnailImage.accept(image)
            } onError: { (error) in
                print(error.localizedDescription)
            }.disposed(by: self.disposeBag)
    }
    
    private func downloadMainImage(urlString: String) {
        ImageDownloadServices.shared.downloadImage(urlString: urlString)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (image) in
                guard let self = self else { return }
                self.image.accept(image)
            } onError: { (error) in
                print(error.localizedDescription)
            }.disposed(by: self.disposeBag)
    }
    
}
