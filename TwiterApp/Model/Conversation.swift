//
//  Conversation.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import Foundation

struct Conversation {
    var messageId: String?
    var timeStamp: Date!
    var user: User
    var latestMessage: String?
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        
        if let messageId = dictionary["messageId"] as? String {
            self.messageId = messageId
        }
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
    }
}
