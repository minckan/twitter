//
//  MessageService.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift


enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}

struct MessageService {
    static let shared = MessageService()
    
    func fetchChannels() {
        
    }
    func fetchMessages() {
        
    }
}


class ChannelFirestoreStream {
    private let storage = Storage.storage().reference()
    let firestoreDatabase = Firestore.firestore()
    var listener: ListenerRegistration?
    lazy var ChannelListener: CollectionReference = {
        return firestoreDatabase.collection("channels")
    }()
    
    func createChannel(to user: User) -> Channel {
        var dictionary : [String: Any] = [:]
        dictionary["timestamp"] = Int(NSDate().timeIntervalSince1970)
        var channel = Channel(receiver: user, dictionary: dictionary)
        var ref: DocumentReference? = nil
        ref = ChannelListener.addDocument(data: channel.representation) { error in
            if let error = error {
                print("DEBUG: Error saving Channel : \(error.localizedDescription)")
            }
        }
        
        if let channelId = ref?.documentID {
            channel.id = channelId
        }
        
        return channel
    }
    
    func subscribe(completion: @escaping (Result<[(Channel, DocumentChangeType)], Error>) -> Void) {
        ChannelListener.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            
            let result = snapshot.documentChanges
                .filter { Channel($0.document) != nil }
                .compactMap {(Channel($0.document)!, $0.type)}
            
            completion(.success(result))
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    func removeCache() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let db = Firestore.firestore()
        db.settings = settings

        // Clear local cache
        db.clearPersistence(completion: { (error) in
            if let error = error {
                print("Error clearing persistence: \(error)")
            } else {
                print("Persistence successfully cleared")
            }
        })
    }
}

class ChatFirestoreStream {
    
    private let storage = Storage.storage().reference()
    let firestoreDataBase = Firestore.firestore()
    var listener: ListenerRegistration?
    var collectionListener: CollectionReference?
    
    func subscribe(id: String, completion: @escaping (Result<[Message], StreamError>) -> Void) {
        let streamPath = "channels/\(id)/thread"
        
        removeListener()
        collectionListener = firestoreDataBase.collection(streamPath)
        
        listener = collectionListener?
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    completion(.failure(StreamError.firestoreError(error)))
                    return
                }
                
                var messages = [Message]()
                snapshot.documentChanges.forEach { change in
                    if let message = Message(document: change.document) {
                        if case .added = change.type {
                            messages.append(message)
                        }
                    }
                }
                completion(.success(messages))
            }
    }
    
    func save(_ message: Message, completion: ((Error?) -> Void)? = nil) {
        collectionListener?.addDocument(data: message.representation) { error in
            completion?(error)
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
}
