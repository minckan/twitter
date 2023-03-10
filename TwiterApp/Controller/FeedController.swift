//
//  FeedController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    // MARK: - Properties
    var user : User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
        
        
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else {return}
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
