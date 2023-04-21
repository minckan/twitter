//
//  MainTabController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    var user : User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(ActionButtonTabbed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
        
    }
    
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    @objc func ActionButtonTabbed() {
        guard let user = user else {return}
        let controller = UploadTweetsController(user: user, config: .tweet)
       let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        delegate = self
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notification = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notification)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        setNavigationBarColor(color: .white)
        return nav
    }
}

extension MainTabController: UITabBarControllerDelegate {
    /*
     Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
     ref: https://developer.apple.com/documentation/uikit/uitabbarcontrollerdelegate/1621167-tabbarcontroller
     */
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // toView 먼저 containerView에 추가하고 alpha 값 조절
        toView.alpha = 0.0
        containerView.addSubview(toView)
        
        // fade-in 효과
        UIView.animate(withDuration: duration / 2, animations: {
            toView.alpha = 1.0
        }) { _ in
            // fade-in 완료 후 fade-out 효과 적용
            UIView.animate(withDuration: self.duration / 2, animations: {
                fromView.alpha = 0.0
            }, completion: { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}
