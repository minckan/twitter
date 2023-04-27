//
//  SideMenuNavigationController.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/27.
//

import SideMenu

class CustomSideMenuNavigationController: SideMenuNavigationController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
        

        self.presentationStyle = .menuSlideIn
        self.presentationStyle.backgroundColor = .black
        self.presentationStyle.presentingEndAlpha = 0.5
        self.leftSide = true

        self.statusBarEndAlpha = 0.0
        self.menuWidth = (UIScreen.main.bounds.width / 5) * 4
    }

}
