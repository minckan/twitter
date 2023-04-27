//
//  SideMenuCell.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/27.
//

import UIKit

class SideMenuCell : UICollectionViewCell {
    
    var option: SideMenuOptions! {
        didSet {
            configure()
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configure() {
        let image = option.image
        let view = Utilities().menuOptionView(withImage: image, text: option.description)
        
        addSubview(view)
    }
}
