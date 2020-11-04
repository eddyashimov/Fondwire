//
//  FeedController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import FirebaseAuth
import ProgressHUD


private let feedsReuseID = "feedsCell"
private let feedsEventReuseID = "feedsEventCell"
var selectedIndexPath = IndexPath()

class FeedController: UICollectionViewController {
    
    
    //MARK: - Properties
        var webView = WKWebView()
    
    var feeds =  [Feed]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var user: User?
        
    private let filterBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(handleFilterTapped), for: .touchUpInside)
        button.tintColor = .fwYellow
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .fwDarkBlueFg
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdatedFromFeed"), object: nil)
    }

    override func viewDidLoad() {
        super .viewDidLoad()
        ProgressHUD.show("Loading Feeds")

        configureUI()
        fetchFeeds()
        fetchUser()
    }
    
     //MARK: - API
     
    func fetchUser() {
        if Auth.auth().currentUser != nil {
            UserService.shared.fetchUser(uid: Auth.auth().currentUser!.uid) { (user) in
                self.user = user
            }
        }
    }
    
    func fetchFeeds()  {
        FeedService.shared.fetchFeed { (feed) in
            self.feeds = feed
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        let barButton = UIBarButtonItem(customView: filterBarButton)
         navigationItem.rightBarButtonItem = barButton
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: feedsReuseID)
        collectionView.register(FeedEventCollectionViewCell.self, forCellWithReuseIdentifier: feedsEventReuseID)
        setNeedsStatusBarAppearanceUpdate()
        collectionView.backgroundColor = .fwFeedBackground
        navigationItem.title = "ALL FEEDS"
        collectionView.showsVerticalScrollIndicator =
        false
        presentOnboardingController()
    }
    
    func presentOnboardingController()  {
        if defaults.bool(forKey: "userLoggedIn") == false {
            let controller = WelcomeController()
            controller.modalPresentationStyle = .fullScreen
            controller.delegate = self
            present(controller, animated: false, completion: nil)
        } 

    }
    

    
    //MARK: - Selectors
    
    @objc func handleFilterTapped() {
        comingSoon()
    }
    
    func presentLoginController()  {
        let controller = LoginController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func presentCompanyInfoController() {
        let controller = CompanyInfoController()
        controller.delegate = self
        controller.user =  user
        controller.isPresentedFromFeedVC = true
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func presentFeedDetailController(withFeed feed: Feed) {
        let detailController = FeedDetailController(feed: feed)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func presentWebController(withUrl url: String)  {
        let webViewController = WKWebViewContoller()
        webViewController.url = url
        navigationController?.pushViewController(webViewController, animated: true)
    }

}

extension FeedController: WelcomeControllerDelegate {
    func welcomeViewDismissed() {
        
        if defaults.bool(forKey: "userLoggedIn") == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                
                let controller = AssetManagerController()
                controller.modalPresentationStyle = .formSheet
                let nav = UINavigationController(rootViewController: controller)
                nav.navigationBar.tintColor = .white
                nav.navigationBar.barTintColor = .fwDarkBlueFg
                nav.navigationBar.barStyle = .black
                nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.gothamBold(ofSize: 16)]
                self.present(nav, animated: true, completion: nil)
            }
            defaults.set(true, forKey: "userLoggedIn")
        }

    }
}

// MARK: - UICollectionViewDataSource/Delegate

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let feed = feeds[indexPath.row]
        if feed.type == .event {
            let cell:FeedEventCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: feedsEventReuseID, for: indexPath) as! FeedEventCollectionViewCell
            cell.feed = feeds[indexPath.row]
            return addShadowToCell(cell)
        } else {
            let cell:FeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: feedsReuseID, for: indexPath) as! FeedCollectionViewCell
            cell.feed = feeds[indexPath.row]
            cell.contentView.isUserInteractionEnabled = false
            return addShadowToCell(cell)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        if Auth.auth().currentUser == nil {
            presentLoginController()
        
        } else {
            if user?.companyName != "" {
                let feed = feeds[indexPath.row]
                if feed.type == .event {
                    guard let url = feed.url else { return }
                    presentWebController(withUrl: url)
                } else {
                   presentFeedDetailController(withFeed: feed)
                }
            } else {
            presentCompanyInfoController()
            }
        }
    }
}

private func addShadowToCell(_ cell: UICollectionViewCell) -> UICollectionViewCell {
    cell.contentView.isUserInteractionEnabled = false
    cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
   
    return cell
}


// MARK: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = FeedViewModel(feed: feeds[indexPath.row])
        

        let feed = feeds[indexPath.row]
        var height = viewModel.size(forWidth: view.frame.width).height + 110
        var width = view.frame.width
        
            switch feed.type {
            case .article: height += 100
            case .video: height += 250
            case .podcast: print("")
            case .event: height += 100
            }
        if feed.type == .event {
            width *= 0.95
        }
        return CGSize(width: width, height: height)
       }

}


extension FeedController: CompanyInfoControllerDelegate {
    func companyDidSpecified() {
        fetchUser()
    }
}

extension FeedController: LoginControllerDelegate {
    func loginCompleted() {
        collectionView(collectionView, didSelectItemAt: selectedIndexPath)
        fetchUser()
    }
}


