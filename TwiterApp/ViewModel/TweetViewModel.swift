//
//  TweetViewModel.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/18.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user : User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: tweet.timeStamp, to: now) ?? "2m"
    }
    
    var headerTimeStamp : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a ﹒MM/dd/yyyy"
        return dateFormatter.string(from: tweet.timeStamp)
    }
    
    var retweetsAttributedString : NSAttributedString {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString : NSAttributedString {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var userInfoText : NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var likeImage : UIImage {
        var image = UIImage()
        
        if tweet.didLike {
            image = UIImage(named: "like_filled")?.withTintColor(.red, renderingMode: .alwaysOriginal) ?? UIImage()
        } else {
            image = UIImage(named: "like") ?? UIImage()
        }
        
        return image
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    
    fileprivate func attributedText(withValue value : Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    

}

