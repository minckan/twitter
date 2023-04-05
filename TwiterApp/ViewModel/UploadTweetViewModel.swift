//
//  UploadTweetViewModel.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/05.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case replay(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle : String
    let placeholderText : String
    var shouldShowReplyLabel : Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
            
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening?"
            shouldShowReplyLabel = false
        case .replay(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
