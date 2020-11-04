//
//  MessagesControllers.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

private let messagesReuseId = "messagesCell"

class MessagesController: UITableViewController {
    
    //MARK: - Properties
    private lazy var headerView = MessageHeaderView()

    
    //MARK: - Lifecycle

    
    override func viewDidLoad() {
        super .viewDidLoad()
        configureUI()
        sizeHeaderToFit()

     }

    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .fwDarkBlueBg
        navigationItem.title = "MESSAGES"
        tableView.register(MessageTableCell.self, forCellReuseIdentifier: messagesReuseId)
        tableView.rowHeight = 100
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.frame.width)
        tableView.tableHeaderView = headerView
        headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame

        tableView.tableHeaderView = headerView
    }
    
    
    //MARK: - Selectors
    
}

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messagesReuseId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comingSoon()
    }
}



