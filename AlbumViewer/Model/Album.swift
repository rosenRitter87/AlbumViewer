//
//  Album.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation

struct Album: Codable, Identifiable {
    var id: Int
    var userId: Int
    var title: String
}
