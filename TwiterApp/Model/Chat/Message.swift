//
//  Message.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import Foundation
import MessageKit
import UIKit
import FirebaseFirestore
import FirebaseAuth

struct Sender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let content: String
    let sentDate: Date
    let sender: SenderType
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageMediaItem(image: image)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    var image : UIImage?
    var downloadURL: URL?
    
    init(user: User, withContent content: String) {
        sender = Sender(senderId: Auth.auth().currentUser?.uid ?? "", displayName: UserDefaultManager.displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(user: User, withImage image: UIImage) {
        sender = Sender(senderId: Auth.auth().currentUser?.uid ?? "", displayName: UserDefaultManager.displayName)
        self.image = image
        sentDate = Date()
        content = ""
        id = nil
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String else {return nil}
        
        id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
}

extension Message : DatabaseRepresentation {
    var representation: [String : Any] {
        var representation : [String:Any] = [
            "created" : sentDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            representation["url"] = url.absoluteString
        } else {
            representation["content"] = content
        }
        
        return representation
    }
}

extension Message: Comparable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}
