//
//  Common.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit

func setNavigationBarColor(color: UIColor, textColor: UIColor? = .black) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()
    appearance.backgroundColor = color
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    
}
