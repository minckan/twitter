//
//  Channel.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Channel {
    var senderId: String?
    var id: String?
    var timestamp: Date!
    var latestMessage: String?
    var receiverId: String?
    var receiverName: String?
    
    init(receiver: User, dictionary: [String: Any]) {
        if let id =  Auth.auth().currentUser?.uid {
            self.senderId = id
        }
        if let messageId = dictionary["id"] as? String {
            self.id = messageId
        }
        if let timestamp = dictionary["timestamp"] as? Int {
            self.timestamp = Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
        self.receiverId = receiver.uid
        self.receiverName = receiver.username
        
    }
    
    init?(_ document: QueryDocumentSnapshot) {
        let data = document.data()
        id = document.documentID
        
        if let id =  Auth.auth().currentUser?.uid {
            self.senderId = id
        }
        if let timestamp = data["timestamp"] as? Int {
            self.timestamp = Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        if let receiverId = data["receiverId"] as? String {
            self.receiverId = receiverId
        }
        if let receiverName = data["receiverName"] as? String {
            self.receiverName = receiverName
        }
    }
}

extension Channel : DatabaseRepresentation {
    var representation: [String : Any] {
        var rep : [String: Any] = [:]
        rep["receiverId"] = self.receiverId
        rep["receiverName"] = self.receiverName
        if let timestamp = timestamp {
            rep["timestamp"] = Int(exactly: timestamp.timeIntervalSince1970)
        }
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
        return lhs.timestamp < rhs.timestamp
        
    }
}
