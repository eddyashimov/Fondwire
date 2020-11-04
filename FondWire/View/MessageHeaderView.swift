//
//  MessageHeaderView.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/18/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class MessageHeaderView: UIView {
    private let actionsView = MessageActionsView()
    private let msgCountStack: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        let messageLbl = UILabel()
        messageLbl.text = "MESSAGES"
        messageLbl.textColor = .lightText
        messageLbl.font = .gothamLight(ofSize: 16)
        messageLbl.textAlignment = .left
        view.addArrangedSubview(messageLbl)
        return view
    }()
    
    private let msgCountLbl: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .gothamMedium(ofSize: 16)
        label.textColor = .fwYellow
        label.textAlignment = .right
        label.setDimensions(height: 20, width: 40)
        return label
    }()

        override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .fwDarkBlueBg
        addSubview(actionsView)
        actionsView.center(inView: self)
        actionsView.setDimensions(height: 270, width: 260)
        actionsView.anchor(top: topAnchor, paddingTop: 30)
        addSubview(msgCountStack)
        msgCountStack.addArrangedSubview(msgCountLbl)
        msgCountStack.anchor(bottom: bottomAnchor)
        msgCountStack.centerX(inView: self)
    }
    
    override func layoutSubviews() {
        msgCountStack.setDimensions(height: 40, width: 320)
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(0.25)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: frame.height-separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor(white: 0.3, alpha: 1)
        self.addSubview(additionalSeparator)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
