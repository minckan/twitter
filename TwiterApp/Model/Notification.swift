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
    var tweetId: String?
    var timeStamp: Date!
    var user : User
    var type: NotificationType!
    
    init(user: User,  dictionary: [String: AnyObject]) {
        self.user = user
        
        
        if let tweetId = dictionary["tweetID"] as? String {
            self.tweetId = tweetId
        }
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
