//
//  SessionManagerImp.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct UserSessionDetails {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let preferredGender: String
}

protocol SessionManager {
    var userDetails: UserSessionDetails? { get }
    init()
    func logout()
}

final class SessionManagerImp: SessionManager, ObservableObject {
    
    @Published var userDetails: UserSessionDetails?
    @Published var signedIn = false
    
    private var activeMale = [Therapist]()
    private var activeFemale = [Therapist]()
    var isSignedIn : Bool {
        return Auth.auth().currentUser != nil
    }
    var test : Void {
        if isSignedIn {
            setupObservations()
        }
        return
    }
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupObservations()
    }
    
    deinit {
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
        print("deinit SessionServiceImpl")
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}

private extension SessionManagerImp {
    
    func setupObservations() {
        
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                
                let currentUser = Auth.auth().currentUser
                self.signedIn = currentUser == nil ? false : true
                
                if let uid = currentUser?.uid {
                    
                    Database
                        .database()
                        .reference()
                        .child("users")
                        .child(uid)
                        .observeSingleEvent(of: .value, with: { snapshot  in
                            
                            guard
                                  let value = snapshot.value as? NSDictionary,
                                  let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                                  let lastName = value[RegistrationKeys.lastName.rawValue] as? String,
                                  let phoneNumber = value[RegistrationKeys.phoneNumber.rawValue] as? String,
                                  let preferredGender = value[RegistrationKeys.preferredGender.rawValue] as? String else {
                                return
                            }
                            
                            
                            
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(firstName, forKey: "firstName")
                                UserDefaults.standard.set(lastName, forKey: "lastName")
                                UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                                UserDefaults.standard.set(preferredGender, forKey: "preferredGender")
                                
                                print("DEBUG: user default saved successfully")
                            }
                        })
                }
            }
    }
}

