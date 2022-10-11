//
//  AppManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

// Create a protocol with the following
/**
 * Init
 * state
 * Publisher to return the user so in the view model you can map and create a struct
 */

enum SessionState {
    case loggedIn
    case loggedOut
}

struct UserSessionDetails {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let preferredGender: String
}

protocol SessionManager {
//    var state: SessionState { get }
    var userDetails: UserSessionDetails? { get }
    init()
    func logout()
}

final class AppManager: SessionManager, ObservableObject {
    
//    @Published var state: SessionState = .loggedOut
    @Published var userDetails: UserSessionDetails?
    @Published var signedIn = false
    
    var isSignedIn : Bool {
        return Auth.auth().currentUser != nil
    }
    
    private var handler: AuthStateDidChangeListenerHandle?
    private var subscriptions = Set<AnyCancellable>()
    
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

private extension AppManager {
    
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
                        .observe(.value, with: { [weak self] snapshot  in
                            
                            guard let self = self,
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
                                self.userDetails = UserSessionDetails(firstName: firstName,
                                                                      lastName: lastName,
                                                                      phoneNumber: phoneNumber,
                                                                      preferredGender: preferredGender)
                                print("DEBUG: user default saved successfullyy")
                            }
                        })
                }
            }
    }
}
