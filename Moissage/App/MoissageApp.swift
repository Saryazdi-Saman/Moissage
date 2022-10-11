//
//  MoissageApp.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MoissageApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = AppManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if sessionService.signedIn {
                    MainView()
                        .environmentObject(sessionService)
                } else{
                    LoginView()
                }
                //                if appManager.signedIn {
                //                    MainView()
                //
                //                } else {
                //                    LoginView()
                //                        .environmentObject(appManager)
                //                }
            }
            .onAppear{
                sessionService.signedIn = sessionService.isSignedIn
            }
            
        }
    }
}
