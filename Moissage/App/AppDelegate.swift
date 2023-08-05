//
//  AppDelegate.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-21.
//
import SwiftUI
import Firebase
import StripePaymentSheet

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        StripeAPI.defaultPublishableKey = K.Stripe.publicKey.rawValue
        
        return true
    }
}
