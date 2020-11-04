//
//  AssetsCustomCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/16/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class AssetsTableCell: UITableViewCell {
    
    var asset: Asset? {
        didSet {
            configure()
        }
    }
    
    private lazy var assetProfileImgVw: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.setDimensions(width: 48, height: 48)
        imgView.layer.cornerRadius = 48/5
        imgView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        imgView.image = #imageLiteral(resourceName: "logo7")
        return imgView
    }()
    
    private let assetNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .gothamLight(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.text = "Vanguard 500 Idx;Adm"
        return lbl
    }()
    
    private let assetSymbolLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = .gothamThin(ofSize: 10)
         lbl.numberOfLines = 0
        lbl.textColor = .darkGray
         lbl.text = "VFIAX"
         return lbl
     }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("FOLLOW", for: .normal)
        button.setTitle("FOLLOWING", for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .gothamBold(ofSize: 8)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
           var frame = newFrame
            let newWidth = frame.width * 0.95 // get 90% width here
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            frame.origin.y += 10

            super.frame = frame
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .yellow
        selectionStyle = .none
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(3.0)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: 110-separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = .fwFeedBackground
        self.addSubview(additionalSeparator)
        
        let labelStack = UIStackView(arrangedSubviews: [assetNameLabel, assetSymbolLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 0
        labelStack.alignment = .leading
        
        let mergedStack = UIStackView(arrangedSubviews: [assetProfileImgVw, labelStack])
        mergedStack.axis = .horizontal
        mergedStack.spacing = 15
        addSubview(mergedStack)
        mergedStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 10)
        addSubview(followButton)
        followButton.anchor(top: mergedStack.bottomAnchor, right: mergedStack.rightAnchor, paddingRight: 5)
        followButton.setDimensions(height: 20, width: 90)
        followButton.layer.cornerRadius = 20/5
    }
    
    func configure()  {
         guard let asset = asset else { return }
         assetNameLabel.text = asset.name
        assetSymbolLabel.text = asset.type
//         assetSymbolLabel.text = user.fullname
        
//        if let profileImageURL = user.profileImageUrl {
//            assetProfileImgVw.sd_setImage(with: user.profileImageUrl)
//        } else {
            assetProfileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
//        }
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFollowButtonTapped() {
    }
    
}
