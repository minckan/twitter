//
//  SideMenuHeader.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/27.
//

import UIKit

class SideMenuHeader : UICollectionReusableView {
    // MARK: - Properties
    var user : User? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.setDimensions(width: 70, height: 70)
        iv.layer.cornerRadius = 70 / 2
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let follwersLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor,left: leftAnchor, paddingLeft: 12)
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 12)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [followingLabel, follwersLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let user = user else {return}
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        let viewModel = ProfileHeaderViewModel(user: user,withTextColor: .white)
        
        follwersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}
