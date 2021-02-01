//
//  MockAlbumsServicesClient.swift
//  AlbumViewerTests
//
//  Created by Hamza Nejjar on 01/02/2021.
//

import Foundation
import RxSwift
@testable import AlbumViewer

class MockAlbumsServicesClient {
    var shouldReturnError = false
    
    func reset() {
        shouldReturnError = false
    }
    
    func loadJson(fileName: String) throws -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            return nil
        }
        
        return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}


enum MockServicesErrors: Error {
    case invalidURL, dataNotFound
}

extension MockAlbumsServicesClient: AlbumsServicesClientProtocol {
    func getUsers() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            if self.shouldReturnError {
                observer.onError(MockServicesErrors.dataNotFound)
            } else {
                do {
                    guard let data = try self.loadJson(fileName: "Users") else {
                        observer.onError(MockServicesErrors.dataNotFound)
                        return Disposables.create()
                    }
                    let decoder = JSONDecoder()
                    let decodedItems = try decoder.decode([FailableDecodable<User>].self, from: data).compactMap({$0.base})
                    observer.onNext(decodedItems)
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getAlbums(userId: Int) -> Observable<[Album]> {
        return Observable.create { observer -> Disposable in
            if self.shouldReturnError {
                observer.onError(MockServicesErrors.dataNotFound)
            } else {
                do {
                    guard let data = try self.loadJson(fileName: "Albums") else {
                        observer.onError(MockServicesErrors.dataNotFound)
                        return Disposables.create()
                    }
                    let decoder = JSONDecoder()
                    let decodedItems = try decoder.decode([FailableDecodable<Album>].self, from: data).compactMap({$0.base})
                    observer.onNext(decodedItems)
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getAlbumDetails(userId: Int, albumId: Int) -> Observable<[AlbumDetails]> {
        return Observable.create { observer -> Disposable in
            if self.shouldReturnError {
                observer.onError(MockServicesErrors.dataNotFound)
            } else {
                do {
                    guard let data = try self.loadJson(fileName: "AlbumDetails") else {
                        observer.onError(MockServicesErrors.dataNotFound)
                        return Disposables.create()
                    }
                    let decoder = JSONDecoder()
                    let decodedItems = try decoder.decode([FailableDecodable<AlbumDetails>].self, from: data).compactMap({$0.base})
                    observer.onNext(decodedItems)
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
