//
//  Profile.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/21.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description : String {
        switch self {
        case.fullname : return "Username"
        case.username : return "Name"
        case.bio : return "Bio"
        }
    }
}

struct EditProfileViewModel {
    private let user : User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue:  String? {
        switch option {
            
        case .fullname: return user.username
        case .username: return user.fullname
        case .bio: return user.bio
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
 
