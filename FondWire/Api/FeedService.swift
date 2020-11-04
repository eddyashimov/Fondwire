//
//  FeedService.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/31/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct FeedService {
    
    static let shared =  FeedService()
    
    func uploadFeed(title: String, type: FeedType, completion: @escaping(Error?, DatabaseReference) -> Void) {

        var values = ["uid": "MPDM0e5yBnbMFap2PJyiSpK2Qw22",
                      "issueDate": Int(NSDate().timeIntervalSince1970),
                      "media": "",
                      "name": "",
                      "logo": "",
                      "teaser": "",
                      "bodyText": "",
                      "link": "",
                      "category": "",
                      "type": type.rawValue,
                      "url": "",
                      "title": title] as [String : Any]
        
        switch type {
        case .article:
            REF_FEEDS_ARTICLE.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        case .video:
            REF_FEEDS_VIDEO.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        case .podcast:
            REF_FEEDS_PODCAST.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        case .event:
            REF_FEEDS_EVENT.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
            values["eventDate"] = ""
        }
    }
    
    func fetchFeeds(completion: @escaping([Feed]) -> Void) {
        var feeds = [Feed]()


    }
    
    func fetchFeed( completion: @escaping([Feed]) -> Void) {
        var feeds = [Feed]()

        REF_FEEDS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: Any] else { return }
            var dict = [String: Any]()
            for (key, value) in snap {
                dict = value as! [String : Any]
                for (key, value) in dict {
                    let feed = dict[key] as! [String : Any]
                    
                    UserService.shared.fetchUser(uid: feed["uid"] as! String) { (user) in
                        let feed = Feed(user: user, dict: feed)
                        feeds.append(feed)
                        completion(feeds)
                    }
                    
                    
                }
            }
            
          
        }
    }
}
