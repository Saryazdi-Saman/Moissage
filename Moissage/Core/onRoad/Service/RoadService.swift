//
//  RoadService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-05.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RoadService {
    
    func fetchAgentProfile(completion: @escaping(Result<Agent,Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var agent : Agent?
        Database.database().reference()
            .child("contracts")
            .child(uid)
            .child("agent")
            .observe(.value, with:{ snapshot in
                guard let value = snapshot.value as? [String:Any],
                      let name = value["name"] as? String,
                      let id = value["id"] as? String
                else {
                    return completion(.failure(NSError()))
                }
                if let path = value["imageUrl"] as? String {
                    agent = Agent(id: id, name: name, imageUrl: path)
                } else {
                    agent = Agent(id: id, name: name)
                }
                if let agent = agent {
                    return completion(.success(agent))
                }
            })
        
    }
    
    func getPhoto(at path: String, completion: @escaping(Result<Data?,Error>) -> Void){
        Storage.storage().reference(forURL: path)
            .getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(data))
                }
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
    
    func cancelSession(completion: @escaping(Result<Bool,Error>)->Void){
        let cancelationURL = URL(string: "https://cancelrequest-qmtthe7q5a-uc.a.run.app")!
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let token = idToken else {
                completion(.failure(NSError()))
                return
            }
            var request = URLRequest(url: cancelationURL)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = try! JSONEncoder().encode(["cancelWithFine" : true])
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request){(data, response, error) in
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                    print("DEBUG: NETWORK RESPONSE: \(String(describing: response))");
                    completion(.failure(NSError()))
                    return
                }
                if let error = error {
                    completion(.failure(error))
                    print("DEBUG: ERRoR: \(error)");
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Bool],
                      let result = json["isCanceled"]
                else {
                    completion(.failure(NSError()))
                    print("DEBUG: MAtchingVM: error in http request")
                    return
                }
                completion(.success(result))
                print("result recieved: is Canceled \(result)")
            }
            task.resume()
        }
    }
}
