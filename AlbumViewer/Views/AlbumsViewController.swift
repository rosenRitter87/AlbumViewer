//
//  AlbumsViewController.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AlbumsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Variables
    let viewModel = AlbumsViewModel()
    let disposeBag = DisposeBag()
    var user: User?
    var didSetUpBinding = false

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBinding()
        if let user = user {
            viewModel.getAlbums(userId: user.id)
        }
    }
    
    
    //MARK: - RxSwift
    private func setupBinding() {
        //avoid setting binders twice
        if didSetUpBinding {
            return
        }
        didSetUpBinding = true
        
        //setting binders
        
        //TableView
        viewModel.albums.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "AlbumTableViewCell", cellType: AlbumTableViewCell.self)) { index, album, cell in
            cell.albumTitle.text = album.title
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Album.self)
            .subscribe(onNext: { [weak self] album in
                guard let self = self else { return }
                self.goToAlbumDetailsView(album: album)
            })
            .disposed(by: disposeBag)
        
        //progress HUD
        viewModel.webServiceStatus
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] webServiceStatus in
                guard let self = self else { return }
                self.manageHUDView(webServiceStatus: webServiceStatus)
            }).disposed(by: disposeBag)

    }
}

//MARK: - Helpers

extension AlbumsViewController {
    private func goToAlbumDetailsView(album: Album) {
        let albumDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AlbumDetailsViewController") as! AlbumDetailsViewController
        albumDetailsViewController.album = album
        navigationController?.pushViewController(albumDetailsViewController, animated: true)
    }
    
    private func manageHUDView(webServiceStatus: WebserviceStatus) {
        switch webServiceStatus {
        case.loading:
            SVProgressHUD.show()
            break
        case .failed:
            SVProgressHUD.showError(withStatus: "Failed")
            break
        case .success:
            SVProgressHUD.dismiss()
            break
        default:
            break
        }
    }
}
