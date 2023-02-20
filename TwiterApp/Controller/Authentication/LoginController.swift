//
//  File.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/21.
//

import UIKit

class LoginController : UIViewController {
    // Mark: - Properties
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    // Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // Mark: - Selectors
    
    // Mark: - Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black // 화이트로 변한다고 했으나 변하지 않음
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        view.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    }
}
