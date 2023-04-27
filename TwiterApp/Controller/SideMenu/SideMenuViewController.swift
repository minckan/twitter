//
//  SideMenuController.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/27.
//

import UIKit

private let headerReuseIdentifier = "SideMenuHeader"
private let reuseIdentifier = "SideMenuCell"


enum SideMenuOptions : Int, CaseIterable {
    case profile
    case lists
    case logout
    
    var description : String {
        switch self {
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .profile: return #imageLiteral(resourceName: "ic_person_outline_white_2x")
        case .lists: return #imageLiteral(resourceName: "ic_menu_white_3x")
        case .logout: return #imageLiteral(resourceName: "baseline_arrow_back_white_24dp")
        }
    }
    
}

class SideMenuViewController: UICollectionViewController {
    // MARK: - Properties
    private let user: User
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureUI()
        
        collectionView.register(SideMenuHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.register(SideMenuCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .twitterBlue
    }
}

// MARK: - HeaderUI
extension SideMenuViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! SideMenuHeader
        
        header.user = user
        
        return header
    }
}

// MARK: - CellUI
extension SideMenuViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SideMenuOptions.allCases.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SideMenuCell
        
        cell.option = SideMenuOptions(rawValue: indexPath.row)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let option = SideMenuOptions(rawValue: indexPath.row) else {return}
        
      
        if option == .profile {
            let controller = ProfileController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        }
        
        if option == .lists {
            
        }
        
        if option == .logout {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
                AuthService.shared.logUserOut {
                    let nav = UINavigationController(rootViewController: LoginController())
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                    
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SideMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

