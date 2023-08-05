//
//  RoadService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-05.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RoadService {
    
    func fetchAgentProfile(completion: @escaping(Result<Agent,Error>, _ handler: UInt?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var agent : Agent?
        let handler = Database.database().reference()
            .child("contracts")
            .child(uid)
            .child("agent")
            .observe(.value, with:{ snapshot in
                guard let value = snapshot.value as? [String:Any],
                      let name = value["name"] as? String,
                      let id = value["id"] as? String
                else {
                    return completion(.failure(NSError()), nil)
                }
                
                if let image = value["imageUrl"] as? String {
                    agent = Agent(id: id, name: name, imageUrl: image)
                } else {
                    agent = Agent(id: id, name: name)
                }
            })
        if let agent = agent {
            completion(.success(agent), handler)
        }
    }
    
    func stopListening(handler: UInt) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference()
            .child("contracts")
            .child(uid)
            .child("agent")
            .removeObserver(withHandle: handler)
    }
}
