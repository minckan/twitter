//
//  Tweet.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/03/16.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    var likes: Int
    var timeStamp: Date!
    let retweetCount: Int
    var user: User
    var didLike = false
    var replyingTo: String?
    
    var isReply : Bool {return replyingTo != nil}
    
    init(user: User, tweetId: String, dictionary: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}
