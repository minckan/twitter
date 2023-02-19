//
//  Common.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit

func setNavigationBarColor() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}
