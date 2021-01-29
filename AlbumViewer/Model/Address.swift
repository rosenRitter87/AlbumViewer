//
//  Address.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import Foundation

struct Address: Codable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Coordinates?
}
