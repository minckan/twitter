//
//  EditProfileCell.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/21.
//

import UIKit

class EditProfileCell: UITableViewCell {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
}
