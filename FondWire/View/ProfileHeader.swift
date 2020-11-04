//
//  ProfileHeader.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/21/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import SDWebImage


protocol ProfileHeaderDelegate: class {
    func didSelect(filter: ProfileFilterOptions)
    func didTapProfileChangePhoto()

}

class ProfileHeader: UICollectionReusableView {
        
    weak var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            configureProfileInfo()
        }
    }
    var asset: Asset? {
          didSet {
              configureAssetProfileInfo()
          }
      }
        
    private let backgroundImgVw: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profileBack")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var profileImgVw: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile_placeholder")
        imageView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        imageView.setDimensions(height: 70, width: 70)
        imageView.layer.cornerRadius = 70/2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private let profileNameLbl: UILabel = {
        let label = UILabel()
        label.text = "SIGNED OUT"
        label.font = .gothamBold(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.text = "Financial Advisor, Fondwire"
        label.font = .gothamLight(ofSize: 10)
        label.textColor = UIColor(white: 0.8, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private var circleView: UIView!
    private var buttonsView = [UIView]()
    private let actionsStack = UIStackView()
    
    private let filterBar = ProfileFilterView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupActionButtons { () -> () in
            setupStack()
        }
    }
    
    
    func configureUI()  {
        backgroundColor = .fwDarkBlueBg
        addSubview(backgroundImgVw)
        backgroundImgVw.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: frame.height*0.40)
        
        circleView = UIView()
        circleView.backgroundColor = UIColor.init(red: 36/255, green: 189/255, blue: 250/255, alpha: 0.6)
        circleView.alpha = 1
        circleView.setDimensions(height: 80, width: 80)
        circleView.layer.cornerRadius = 80/2
        addSubview(circleView)
        circleView.center(inView: self)
        circleView.addSubview(profileImgVw)
        profileImgVw.center(inView: circleView)
        
        let profileImgTap = UITapGestureRecognizer(target: self, action: #selector(changeProfilePhoto))
        profileImgVw.addGestureRecognizer(profileImgTap)
        
        
        let stack = UIStackView(arrangedSubviews: [profileNameLbl, positionLabel])
        stack.spacing = 5
        stack.axis = .vertical
        addSubview(stack)
        stack.anchor(top: circleView.bottomAnchor, paddingTop: -15)
        stack.centerX(inView: self)
        
        addSubview(actionsStack)
        actionsStack.anchor(top: stack.bottomAnchor, paddingTop: 15)
        actionsStack.centerX(inView: self)
        actionsStack.spacing = 20
        actionsStack.setDimensions(height: 30, width: frame.width*0.7)
        actionsStack.distribution = .fillEqually
        
        filterBar.delegate = self
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, height: 40)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.frame.origin.y -= frame.height*0.1
    }
    
    //MARK: Helpers

    func configureProfileInfo() {
        
        if let user = user {
            let viewModel = ProfileHeaderViewModel(user: user)
            profileNameLbl.text = viewModel.fullName
            
            if let profileImageURL = user.profileImageUrl {
                profileImgVw.sd_setImage(with: user.profileImageUrl)
            } else {
                profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
            }
            positionLabel.text = user.companyName
        } else {
            profileNameLbl.text = "SIGNED OUT"
            profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
        }
    }
    
    func configureAssetProfileInfo() {
           
           if let asset = asset {
            
            profileNameLbl.text = asset.name
            positionLabel.text = asset.type
            print("DEBUG: Asset name is \(asset.name)")
            
//            let viewModel = ProfileHeaderViewModel(asset: asset)
//               profileNameLbl.text = viewModel.fullName
//
//               if let profileImageURL = user.profileImageUrl {
//                   profileImgVw.sd_setImage(with: user.profileImageUrl)
//               } else {
//                   profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
//               }
//               positionLabel.text = user.companyName
//           } else {
//               profileNameLbl.text = "SIGNED OUT"
//               profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
           }
       }
    
        func setupActionButtons(handleComplete:(()->()))  {
    //        guard let user = user else { return }
    //
//            if Auth.auth().currentUser != nil {
                
                ProfileCurrentUser.allCases.forEach { (title) in
                    
                    switch title {
                    case .followers:
                        createActionButton(withTitle: title.title)
                    case .following:
                        createActionButton(withTitle: title.title)
                    }
                }
             handleComplete()
//            }
        }
    
    func createActionButton(withTitle title: String) {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.fwCyan.cgColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.gothamBold(ofSize: 9)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        buttonsView.append(button)
    }
    
    func setupStack() {
        for view in buttonsView {
            actionsStack.addArrangedSubview(view)
        }
    }
    
    
    //MARK: Selectors
    
    @objc func changeProfilePhoto() {
        self.delegate?.didTapProfileChangePhoto()
    }
    
    @objc func actionButtonTapped() {
        
    }
    
        
}


    
//MARK: ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {

    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}
