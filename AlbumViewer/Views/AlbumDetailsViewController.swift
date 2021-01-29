//
//  AlbumDetailsViewController.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 27/01/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AlbumDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    let viewModel = AlbumDetailsModelView()
    let disposeBag = DisposeBag()
    var album: Album?
    var didSetUpBinding = false
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBinding()
        if let album = album {
            viewModel.getAlbumDetails(userId: album.userId, albumId: album.id)
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
        viewModel.albumDetails.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "AlbumDetailsTableViewCell", cellType: AlbumDetailsTableViewCell.self)) { index, albumDetails, cell in
            cell.albumDetails = albumDetails
        }.disposed(by: disposeBag)
        
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

extension AlbumDetailsViewController {
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
