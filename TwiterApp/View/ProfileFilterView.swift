//
//  ProfileFilterView.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/18.
//

import UIKit

private let reuseIdentifier = "ProfileFilterCell"

protocol ProfileFilterViewDelegate : AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
}

class ProfileFilterView : UIView {
    // MARK: - Properties
    
    weak var delegate : ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView : UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        print("DEBUG: Did init...")
//        print("DEBUG: Frame in init is \(frame.width)")
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    override func layoutSubviews() {
//        print("DEBUG: Did layout subview...")
//        print("DEBUG: Frame in layout subview is \(frame.width)")
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileFilterView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilteroption.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        
        cell.option = ProfileFilteroption(rawValue: indexPath.row)
     
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileFilterView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        
//        print("DEBUG: Delegate action to profile header from filter bar...")
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileFilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilteroption.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}




