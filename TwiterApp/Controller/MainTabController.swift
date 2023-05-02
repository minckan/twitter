//
//  MainTabController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit
import FirebaseAuth


enum TapButtons: Int,CaseIterable  {
    case feed
    case explore
    case notification
    case message
    
    
    var description : String {
        switch self {
        case .feed: return "Feed"
        case .explore: return "Explore"
        case .notification: return "Notification"
        case .message: return "Message"
        }
    }
    var controller : UIViewController {
        switch self {
            
        case .feed:
            return FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        case .explore:
            return ExploreController()
        case .notification:
            return NotificationController()
        case .message:
            return ConversationsController()
        }
    }
}


class MainTabController: UITabBarController {
    
    // MARK: - Properties
    var user : User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
            
            UserDefaultManager.displayName = user?.username ?? ""
        }
    }
    
    private var selectedTap:TapButtons?
    
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
    
    
    // MARK: - Selectors
    @objc func ActionButtonTabbed() {
        guard let user = user else {return}
        var controller:UIViewController = UploadTweetsController(user: user, config: .tweet)
        var nav = UINavigationController(rootViewController: controller)

        if self.selectedTap == .message {
            controller = ExploreController()
            nav = UINavigationController(rootViewController: controller)
        }
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
        
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), option: TapButtons.feed)
        
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), option: TapButtons.explore)
        
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), option: TapButtons.notification)
        
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), option: TapButtons.message)
        
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, option: TapButtons) -> UINavigationController {
        let nav = UINavigationController(rootViewController: option.controller)
        nav.tabBarItem.image = image
        nav.tabBarItem.tag = option.rawValue
        
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
  
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController {
            navController.delegate = self
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tap = TapButtons(rawValue: item.tag) else {return}
        self.selectedTap = tap
        if self.selectedTap == .message {
            actionButton.setImage(UIImage(named: "ic_mail_outline_white_2x-1"), for: .normal)
        } else {
            actionButton.setImage(UIImage(named: "new_tweet"), for: .normal)
        }
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

extension MainTabController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let VC = viewController as? ChatController {
            actionButton.isHidden = true
        } else {
            actionButton.isHidden = false
        }
    }
}
