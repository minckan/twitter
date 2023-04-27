//
//  ProfileHeaderViewModel.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/19.
//

import UIKit


enum ProfileFilteroption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }

}


struct ProfileHeaderViewModel {
    private let user : User
    let textColor: UIColor?
    
    let usernameText : String
    
    var followersString: NSAttributedString? {
        if let color = textColor {
            return attributedTextWithColor(withValue: user.stats?.followers ?? 0, text: "followers", color: color)
        }
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    var followingString: NSAttributedString? {
        if let color = textColor {
            return attributedTextWithColor(withValue: user.stats?.following ?? 0, text: "following", color: color)
        }
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle : String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Roading.."
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
        self.textColor = nil
    }
    
    init(user: User, withTextColor color: UIColor) {
        self.user = user
        self.usernameText = "@" + user.username
        self.textColor = color
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        
        measurementLabel.text = user.bio
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    fileprivate func attributedText(withValue value : Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    fileprivate func attributedTextWithColor(withValue value : Int, text: String, color: UIColor) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: color])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: color]))
        
        return attributedTitle
    }
}
