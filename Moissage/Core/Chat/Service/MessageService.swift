//
//  MessageService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-04.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

struct MessageService {
    func sendMessage(_ messageText: String, toUser rmtId: String) -> AnyPublisher<Void, Error> {
        
        Deferred {
            Future { promise in
                
                let timeinterval = Date().timeIntervalSince1970
                guard let uid = Auth.auth().currentUser?.uid else {
                    return promise(.failure(NSError()))
                }
                let message = ["from": uid,
                               "to": rmtId,
                               "body": messageText,
                               "time" : timeinterval] as [String : Any]
                
                Database.database().reference()
                    .child("contracts")
                    .child(uid)
                    .child("chats")
                    .child(rmtId)
                    .childByAutoId()
                    .setValue(message) { error, ref in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func observeMessages(contact: String, completion: @escaping(Result<Message,Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference()
            .child("contracts")
            .child(uid)
            .child("chats")
            .child(contact)
            .queryOrdered(byChild: "time")
            .observe(.childAdded, with : {snapshot  in
                print("DEBUG: Value = \(snapshot.value)")
                if let value = snapshot.value as? [String : Any]{
                    let messageId = snapshot.key
//                    let conversation: [Message] = value.compactMap({ dict in
//                        let message = dict.value
                        guard let fromId = value["from"] as? String,
                              let toId = value["to"] as? String,
                              let body = value["body"] as? String else {
                            print("DEBUG: MessageService - message data was incomplete")
                            return
                        }
                    completion(.success(Message(id: messageId,
                                                fromId: fromId,
                                                toId: toId,
                                                body: body,
                                                uid: uid)))
                         
                    }
                else {
                    print("DEBUG: Value = \(snapshot.value)")
                }
            })
    }
}
