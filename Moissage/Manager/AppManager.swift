//
//  AppManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import Foundation
import FirebaseAuth
import Combine

struct RegistrationDetail {
    var email : String
    var password : String
    var firstName : String
    var lastName : String
    var phoneNumber : String
    var preferredGender : String = "any"
}

class AppManager : ObservableObject{
    
    private let auth = Auth.auth()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var signedIn = false
    
    var newUser = RegistrationDetail(email: "",
                                     password: "",
                                     firstName: "",
                                     lastName: "",
                                     phoneNumber: "")
    
    var isSignedIn : Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) {[weak self] result, error in
            guard result != nil , error == nil else {
                return
            }
            
            // Successfully Signed In
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func creatAccount() {
        auth.createUser(withEmail: newUser.email,
                        password: newUser.password) {[weak self] result, error in
            guard result != nil , error == nil else {
                return
            }
            
            //Successfully Signed In
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        Deferred{
            Future { promise in
                Auth.auth()
                    .sendPasswordReset(withEmail: email){error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func signOut(){
        
    }
}
