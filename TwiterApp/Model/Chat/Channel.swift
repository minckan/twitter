//
//  Channel.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import Foundation
import FirebaseFirestore

struct Channel {
    var id: String?
    var timeStamp: Date!
    var user: User
    var latestMessage: String?
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        
        if let messageId = dictionary["id"] as? String {
            self.id = messageId
        }
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
    }
    
    init?(_ document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        id = document.documentID
//        self.user = User()
    }
}

extension Channel : DatabaseRepresentation {
    var representation: [String : Any] {
        var rep = ["name": user.username]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension Channel : Comparable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.user.username < rhs.user.username
        
    }
}
