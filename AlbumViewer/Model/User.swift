//
//  User.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String?
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?
}
