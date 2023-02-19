//
//  NotificationController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit

class NotificationController: UIViewController {
    // Mark: - Properties
    
    // Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    
    }
    
    
    // Mark: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Notifications"
        
    }
}
