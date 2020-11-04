//
//  SelectAssetsController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/16/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseAuth

private let reuseID = "assetsCell"

class AssetManagerController: UITableViewController {
    
    //MARK: - Properties
    
    private var assets = [Asset]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var manager: Asset? {
        didSet {
            fetchAssets()
        }
    }
    private var searchIsActive = false

    private var filterManagers = [Asset]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool{
        return searchController.searchBar.text!.count > 0
        
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        ProgressHUD.show("Loading Asset Managers")
        configureUI()
        fetchAssets()
        configureSearchController()
         NotificationCenter.default.addObserver(self, selector: #selector(updateUser), name: NSNotification.Name(rawValue: "userUpdatedFromFeed"), object: nil)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    @objc func updateUser(){
        //load data here
//        fetchUser()
//        if let manager = manager {
//            if !manager.isAssetManager {
//                navigationItem.leftBarButtonItem = nil
//            } else {
//                navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewContentTapped))
//            }
//        } else {
//            navigationItem.leftBarButtonItem = nil
//
//        }

    }

    //MARK: - Helpers
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user"
//        searchController.searchBar.backgroundColor = .yellow
        searchController.searchBar.tintColor = .fwYellow
        searchController.searchBar.barTintColor = view.backgroundColor
        searchController.searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        definesPresentationContext = false
    }
    
  private func addShadowToCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.contentView.isUserInteractionEnabled = false
        cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

//            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
       
        return cell
    }
    
    func configureUI() {
        view.autoresizesSubviews = false
        navigationItem.title = "ASSET MANAGER"
        tableView.register(AssetsTableCell.self, forCellReuseIdentifier: reuseID)
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        tableView.separatorColor = .fwDarkBlueBg
        tableView.backgroundColor = .fwFeedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchTapped))
        navigationItem.rightBarButtonItem?.tintColor = .fwYellow
        navigationItem.leftBarButtonItem?.tintColor = .lightText
        self.searchController.searchBar.isHidden = true
    }

    func fetchAssets() {
        AssetService.shared.fetchAssets { (assets) in
            self.assets.removeAll(keepingCapacity: true)
            self.assets = assets

            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
        }
    }
    
    //MARK: - Selectors

    @objc func handleSearchTapped() {
        if !searchIsActive {
            self.searchController.searchBar.isHidden = false
            tableView.tableHeaderView = searchController.searchBar
            searchIsActive.toggle()
            searchController.searchBar.becomeFirstResponder()
        } else {
            self.searchController.searchBar.isHidden = true
            tableView.tableHeaderView = nil
            searchIsActive.toggle()
        }
    }
}

extension AssetManagerController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterManagers.count : assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! AssetsTableCell
        let asset = inSearchMode ? filterManagers[indexPath.row] : assets[indexPath.row]
        cell.asset = asset
        return addShadowToCell(cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let asset = assets[indexPath.row]
        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.asset = asset
        controller.modalPresentationStyle = .automatic
//        navigationController?.pushViewController(controller, animated: true)
        navigationController?.present(controller, animated: true, completion: nil)
//        present(controller, animated: true, completion: nil)
    }
    
}

extension AssetManagerController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterManagers = assets.filter({ $0.name.lowercased().contains(searchText) })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handleSearchTapped()
    }
}
