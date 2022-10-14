//
//  SessionManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase



final class SessionManager: ObservableObject {
    
    @Published var signedIn = false
    @Published var addressBook : [Address]?
    
    
    var isSignedIn : Bool {
        return Auth.auth().currentUser != nil
    }
//    var test : Void {
//        if isSignedIn {
//            setupObservations()
//        }
//        return
//    }
    
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

private extension SessionManager {
    
    func setupObservations() {
        
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                
                let currentUser = Auth.auth().currentUser
                self.signedIn = currentUser == nil ? false : true
                
            }
    }
}

