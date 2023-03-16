//
//  TweetCell.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/16.
//

import UIKit

class TweetCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
