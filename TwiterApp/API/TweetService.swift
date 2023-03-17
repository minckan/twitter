//
//  TweetService.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/03/16.
//

import FirebaseDatabase
import FirebaseAuth

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String: Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values,withCompletionBlock: completion)
    }
    
    func fetchTweet(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snpashot in
            guard let dictionary = snpashot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetId = snpashot.key

            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user , tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
           

        }
    }
}
