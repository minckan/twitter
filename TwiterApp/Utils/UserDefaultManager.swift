//
//  UserDefaultManager.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/05/02.
//

import Foundation

struct UserDefaultManager {
    static var displayName: String {
        get {
            UserDefaults.standard.string(forKey: "DisplayName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DisplayName")
        }
    }
}
