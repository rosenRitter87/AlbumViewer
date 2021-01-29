//
//  UsersViewController.swift
//  AlbumViewer
//
//  Created by Hamza Nejjar on 24/01/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class UsersViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Variables
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel: UsersViewModel = UsersViewModel()
    let disposeBag = DisposeBag()
    var didSetUpBinding = false

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupBinding()
        viewModel.getAllUsers()
    }
    
    
    //MARK: - RxSwift
    
    private func setupBinding() {
        //avoid setting binders twice
        if didSetUpBinding {
            return
        }
        didSetUpBinding = true
       
        //setting binders
        
        //Searchbar
        searchController.searchBar.rx.text
            .orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                self.viewModel.search(query: query, selectedScope: self.searchController.searchBar.selectedScopeButtonIndex)
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.selectedScopeButtonIndex
            .observeOn(MainScheduler.instance)
            .subscribe (onNext: { [weak self] selectedScopeButtonIndex in
                guard let self = self else { return }
                self.searchController.searchBar.placeholder = self.viewModel.getSearchPlaceHolder(scope: selectedScopeButtonIndex)
                self.viewModel.search(query: self.searchController.searchBar.text ?? "", selectedScope: selectedScopeButtonIndex)
            }).disposed(by: disposeBag)
        
        //TableView
        viewModel.datasource.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { [weak self] index, user, cell in
            guard let self = self else { return }
            cell.setupCell(user: user, query: self.searchController.searchBar.text ?? "", scope: self.searchController.searchBar.selectedScopeButtonIndex)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.goToAlbumsView(user: user)
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

extension UsersViewController {
    //Setup searchBar
    private func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["name", "username", "email", "phone", "website"]
    }
    
    //go To AlbumsView
    private func goToAlbumsView(user: User) {
        let albumsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AlbumsViewController") as! AlbumsViewController
        albumsViewController.user = user
        navigationController?.pushViewController(albumsViewController, animated: true)
    }
    
    //show proper HUD view
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
