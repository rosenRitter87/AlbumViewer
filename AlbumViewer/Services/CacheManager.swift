//
//  CacheManager.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation

let kCachedUsers = "CachedUsers"
let kCachedAlbums = "CachedAlbums"
let kCachedAlbumDetails = "CachedAlbumDetails"

class CacheManager {
    //Caching users
    class func cacheUsers(users: [User]) {
        try? UserDefaults.standard.setCodable(object: users, forKey: kCachedUsers)
    }
    
    //get cached users
    class func getCachedUsers() -> [User]? {
        return (try? UserDefaults.standard.getCodable(objectType: [User].self, forKey: kCachedUsers))
    }
    
    //Caching albums
    class func cacheAlbums(albums: [Album], userId: Int) {
        try? UserDefaults.standard.setCodable(object: albums, forKey: kCachedAlbums + "ForUser\(userId)")
    }
    
    //get cached albums
    class func getCachedAlbums(userId: Int) -> [Album]? {
        return (try? UserDefaults.standard.getCodable(objectType: [Album].self, forKey: kCachedAlbums + "ForUser\(userId)"))
    }
    
    //Caching album details
    class func cacheAlbumDetails(albumDetails: [AlbumDetails], albumId: Int, userId: Int) {
        try? UserDefaults.standard.setCodable(object: albumDetails, forKey: kCachedAlbumDetails + "ForAlbum\(albumId)ForUser\(userId)")
    }
    
    //get cached album details
    class func getCachedAlbumDetails(albumId: Int, userId: Int) -> [AlbumDetails]? {
        return (try? UserDefaults.standard.getCodable(objectType: [AlbumDetails].self, forKey: kCachedAlbumDetails + "ForAlbum\(albumId)ForUser\(userId)"))
    }
}
