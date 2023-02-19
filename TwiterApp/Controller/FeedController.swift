//
//  FeedController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit

class FeedController: UIViewController {
    // Mark: - Properties
    
    // Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // Mark: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
        
    }
}
