//
//  AlbumDetails.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation

struct AlbumDetails: Codable, Identifiable {
    var id: Int
    var albumId: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}
