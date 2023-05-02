//
//  ConversationCell.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import UIKit

class ConversationCell : UITableViewCell {
    // MARK: - Properties
    var channel : Channel? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48 , height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let latestMentionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Still doing those things?"
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "02:30 PM"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor:  leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, latestMentionLabel])
        
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let channel = channel else {return}
        
        let viewModel = ChatViewModel(channel: channel)
        usernameLabel.text = channel.receiverName as? String ?? ""
        timeLabel.text = viewModel.timestamp
      
    }
    
}
