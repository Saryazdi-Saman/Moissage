//
//  OnlineSatus.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-12.
//

import Foundation
import FirebaseAuth

final class OnlineStatus : ObservableObject{
    @Published var signedIn = false
    private var handler: AuthStateDidChangeListenerHandle?
    init() {
        print("DEBUG: OnlineStatus INIT")
        setupObservations()
//        organizeAddressbook()
    }
    deinit {
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
        print("deinit OnlineStatus")
    }
    private func setupObservations() {
        handler = Auth.auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                let currentUser = Auth.auth().currentUser
                self.signedIn = currentUser == nil ? false : true
            }
    }
}
