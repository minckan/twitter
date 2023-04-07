//
//  ActionSheetViewModel.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/07.
//

import Foundation

class ActionSheetViewModel {
    // MARK: - Properties
    private let user: User
    
    var option: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        results.append(.blockUser)
        
        return results
    }
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    case blockUser
    
    var description : String {
        switch self {
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        case .blockUser: return "Block User"
        }
    }
    
}
