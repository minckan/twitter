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
 
