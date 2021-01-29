//
//  Extensions.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation
import UIKit.UIImage
import AlamofireImage
import RxSwift

//Set AlamofireImage ready for rxswift
extension ImageDownloader: ReactiveCompatible {}
extension Reactive where Base: ImageDownloader {
    //Image download method
    public func download(urlString: String) -> Observable<UIImage> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(ServicesErrors.invalidURL)
                return Disposables.create {}
            }
            let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let requestReceipt = ImageDownloader.default.download(urlRequest) { response in
                if let error = response.error {
                    observer.onError(error)
                } else if let image = response.value {
                    observer.onNext(image)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
               requestReceipt?.request.cancel()
            }
        }
    }
}

//Storing codables
extension UserDefaults {

    func setCodable<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    
    func getCodable<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try JSONDecoder().decode(objectType, from: result)
    }
}

//MARK: - String extension
extension String {
    func getHighlightAttributedString(substring: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        self.ranges(of: substring, options: [NSString.CompareOptions.caseInsensitive]).forEach({attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: $0.nsRange(in: self))})
        return attributedText
    }
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale)
        {
            ranges.append(range)
        }
        return ranges
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
