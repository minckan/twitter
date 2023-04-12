//
//  Notification.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/10.
//

import Foundation

enum NotificationType : Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetId: String
    var timeStamp: Date!
    let user : User
    var type: NotificationType!
    
    init(user: User,  dictionary: [String: AnyObject]) {
        self.user = user
        
        self.tweetId = dictionary["tweetID"] as? String ?? ""
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
