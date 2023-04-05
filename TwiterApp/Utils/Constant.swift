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

let REF_USER_TWEETS = DB_REF.child("user-tweets")

let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")

let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
