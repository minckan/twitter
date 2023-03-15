//
//  Constant.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/28.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let REF_TWEETS = DB_REF.child("tweets")
