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
    
    func createChannel(with channelName: String) -> Channel {
        let channel = Channel(name: channelName)
        ChannelListener.addDocument(data: channel.representation) { error in
            if let error = error {
                print("DEBUG: Error saving Channel : \(error.localizedDescription)")
            }
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
}
