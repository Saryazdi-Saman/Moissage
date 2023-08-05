//
//  MoissageApp.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI
import FirebaseCore

@main
struct MoissageApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionManager()
    
    var body: some Scene {
        WindowGroup {
                if sessionService.signedIn {
                    HomeView()
//                        .environmentObject(LocationSearchViewModel())
                        .environmentObject(sessionService)
                } else{
                    LoginView()
                }
        }
    }
}
