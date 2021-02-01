//
//  AlbumsServicesClientProtocol.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 01/02/2021.
//

import Foundation
import RxSwift

protocol AlbumsServicesClientProtocol {
    func getUsers() -> Observable<[User]>
    func getAlbums(userId: Int) -> Observable<[Album]>
    func getAlbumDetails(userId: Int, albumId: Int) -> Observable<[AlbumDetails]>
}
