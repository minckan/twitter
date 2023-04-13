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
    
    func uploadTweet(caption: String,type: UploadTweetConfiguration , completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String: Any]
        
        
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { err, ref in
                guard let tweetId = ref.key else {return}
                REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
            }
        case .replay(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    func fetchTweet(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        // TODO: - 시간 오름차순으로 정렬 조회
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetId = snapshot.key

            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user , tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }

    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet])->Void) {
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user , tweetId: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) ->Void ) {
        var tweets = [Tweet]()

        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user , tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
        
    }
    
    func likeTweet(forTweet tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetId).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1]) { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
//
//            REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1]) { err, ref in
//                REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1], withCompletionBlock: completion)
//            }
        }
        
        
    }

    
    func checkDidLike(forTweet tweet: Tweet, completion: @escaping(Bool)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
