//
//  NotificationService.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/10.
//

import Foundation
import FirebaseAuth

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970), "uid": uid, "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetId
        }
    }
}
