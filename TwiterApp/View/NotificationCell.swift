//
//  NotificationCell.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/12.
//

import UIKit
import SDWebImage


protocol NotificationCellDelegate: AnyObject {
    func didTappedProfileImage(_ cell: NotificationCell)
}

class NotificationCell : UITableViewCell {
    // MARK: - Properties
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40/2
        iv.backgroundColor = .twitterBlue
              

        return iv
    }()
    

    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some Text ...."
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        // TableViewCell은 contentView가 있다. 따라서 요소에 이벤트를 걸때 요소 위에 만들어야 이벤트가 동작한다.
        contentView.addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc func handleProfileImageTapped() {
        print("111111")
        delegate?.didTappedProfileImage(self)
    }
    
    // MARK: - Helpers
    func configure() {
        guard let notification = notification else {return}
        let viewModel = NotificationViewModel(notification: notification)
        notificationLabel.attributedText = viewModel.notificationText
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)

    }
    
    
}

