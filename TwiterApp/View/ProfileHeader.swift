//
//  ProfileHeader.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/18.
//

import UIKit

class ProfileHeader:UICollectionReusableView {
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers

}
