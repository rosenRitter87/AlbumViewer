//
//  AlbumsServicesClient.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import Foundation
import RxSwift
import Alamofire

class AlbumsServicesClient {
    
    //Set an exception on the session manager in order to trust the server "jsonplaceholder.typicode.com" because it seems that it lacked the proper certification
    private static var Manager: Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["192:168:1:254": .disableEvaluation]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        //Set the delegate with the trust policy
        let delegate: Alamofire.SessionDelegate = manager.delegate
        delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        return manager
    }()
}


extension AlbumsServicesClient: AlbumsServicesClientProtocol {
    //Get users webservice
    
    func getUsers() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            let header: HTTPHeaders = ["Accept": "application/json"]
            AlbumsServicesClient.Manager.request(kBaseUrl + "users", headers: header)
                .validate()
                .responseJSON {  response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServicesErrors.dataNotFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let decodedItems = try decoder.decode([FailableDecodable<User>].self, from: data).compactMap({$0.base})
                            observer.onNext(decodedItems)
                        } catch let error {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    //Get albums webservice
    func getAlbums(userId: Int) -> Observable<[Album]> {
        return Observable.create { observer -> Disposable in
            let header: HTTPHeaders = ["Accept": "application/json"]
            AlbumsServicesClient.Manager.request("\(kBaseUrl)users/\(userId)/albums", headers: header)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServicesErrors.dataNotFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let decodedItems = try decoder.decode([FailableDecodable<Album>].self, from: data).compactMap({$0.base})
                            observer.onNext(decodedItems)
                        } catch let error {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    //Get album photos web service
    func getAlbumDetails(userId: Int, albumId: Int) -> Observable<[AlbumDetails]> {
        return Observable.create { observer -> Disposable in
            let header: HTTPHeaders = ["Accept": "application/json"]
            AlbumsServicesClient.Manager.request("\(kBaseUrl)users/\(userId)/photos?albumId=\(albumId)", headers: header)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServicesErrors.dataNotFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let decodedItems = try decoder.decode([FailableDecodable<AlbumDetails>].self, from: data).compactMap({$0.base})
                            observer.onNext(decodedItems)
                        } catch let error {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
