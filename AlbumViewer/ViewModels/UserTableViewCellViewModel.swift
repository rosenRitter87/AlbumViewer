//
//  UserTableViewCellViewModel.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import Foundation
import UIKit

class UserTableViewCellViewModel {
    func getAttributedName(user: User, query: String, scope: Int) -> NSAttributedString {
        return user.name.getHighlightAttributedString(substring: query, color: .red)
    }
    
    func getAttributedUsername(user: User, query: String, scope: Int) -> NSAttributedString {
        return user.username.getHighlightAttributedString(substring: query, color: .red)
    }
    
    func getAttributedEmail(user: User, query: String, scope: Int) -> NSAttributedString? {
        return user.email?.getHighlightAttributedString(substring: query, color: .red)
    }
    
    func getAttributedPhone(user: User, query: String, scope: Int) -> NSAttributedString? {
        return user.phone?.getHighlightAttributedString(substring: query, color: .red)
    }
    
    func getAttributedWebsite(user: User, query: String, scope: Int) -> NSAttributedString? {
        return user.website?.getHighlightAttributedString(substring: query, color: .red)
    }
}
