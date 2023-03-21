//
//  TweetHeader.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/21.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
