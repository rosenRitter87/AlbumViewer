//
//  UserTableViewCell.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    //MARK: - Variables
    let viewModel = UserTableViewCellViewModel()
    
    //MARK: - Public methods
    //setting up the labels
    func setupCell(user: User, query: String, scope: Int) {
        nameLabel.attributedText = viewModel.getAttributedName(user: user, query: query, scope: scope)
        usernameLabel.attributedText = viewModel.getAttributedUsername(user: user, query: query, scope: scope)
        emailLabel.attributedText = viewModel.getAttributedEmail(user: user, query: query, scope: scope)
        telephoneLabel.attributedText = viewModel.getAttributedPhone(user: user, query: query, scope: scope)
        websiteLabel.attributedText = viewModel.getAttributedWebsite(user: user, query: query, scope: scope)
    }

}
