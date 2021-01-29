//
//  ImageDownloadServices.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 28/01/2021.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireImage

class ImageDownloadServices {
    //Again set an exception on the session manager in order to trust the server "jsonplaceholder.typicode.com" because it seems that it lacked the proper certification
    static var shared: ImageDownloadServices = {
        let delegate: Alamofire.SessionDelegate = ImageDownloader.default.sessionManager.delegate
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
                    credential = ImageDownloader.default.sessionManager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        return ImageDownloadServices()
    }()
    
    
    //Download an image
    func downloadImage(urlString: String) -> Observable<UIImage> {
        return ImageDownloader.default.rx.download(urlString: urlString)
    }
}
