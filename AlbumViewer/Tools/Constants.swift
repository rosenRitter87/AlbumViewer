//
//  Constants.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation

//Webservices base url
let kBaseUrl = "https://jsonplaceholder.typicode.com/"

//Webservices errors
enum ServicesErrors: Error {
    case invalidURL, dataNotFound
}

//Webservices call states
enum WebserviceStatus {
    case none, loading, failed, success
}

// searchbar placeholder texts
enum SearchPlaceholders: String {
    case name = "Search name"
    case username = "Search username"
    case email = "Search email"
    case phone = "Search phone"
    case website = "Search website"
}
