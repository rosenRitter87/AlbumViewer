//
//  AlbumDetailsTableViewCell.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 28/01/2021.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumDetailsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var albumImageView: UIImageView!
    
    //MARK: - Variables
    let viewModel = AlbumDetailsTableViewCellViewModel()
    let disposeBag = DisposeBag()
    var albumDetails: AlbumDetails? {
        didSet {
            setupCell()
        }
    }
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBinding()
    }
    
    //MARK: - RxSwift
    func setupBinding() {
        viewModel.thumbnailImage
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                self.thumbnailImageView.image = nil
                self.thumbnailImageView.image = image
            }).disposed(by: disposeBag)
        
        viewModel.image
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                self.albumImageView.image = nil
                self.albumImageView.image = image
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Private methods
    private func setupCell() {
        if let albumDetails = albumDetails {
            albumTitleLabel.text = albumDetails.title
            viewModel.albumDetails.accept(albumDetails)
        }
    }

}
