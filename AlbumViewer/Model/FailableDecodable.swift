//
//  FailableDecodable.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import Foundation

struct FailableDecodable<Base : Codable> : Codable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
