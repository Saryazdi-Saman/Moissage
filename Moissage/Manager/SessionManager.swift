//
//  SessionManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine



final class SessionManager: ObservableObject {
    
    @Published var signedIn = false
    @Published var addressBook: [Address]?
    @Published var onlineWorkers: [Therapist]?
    @Published var uid : String?
    private let database = Database.database().reference()
    private var cancallables = Set<AnyCancellable>()
    
    static let shared = SessionManager()
    
    var isSignedIn : Bool {
        return Auth.auth().currentUser != nil
    }
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupObservations()
        StartUpdatingDatabase()
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
    
    private func setupObservations() {
        
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                
                let currentUser = Auth.auth().currentUser
                self.signedIn = currentUser == nil ? false : true
                self.uid = currentUser?.uid
            }
    }
    
    private func StartUpdatingDatabase(){
        $uid.sink { [weak self] id in
            guard let uid = id else { return }
            guard let self = self else {return}
                self.updateUserDefaults(forUserWithID: uid)
                self.startListeningForAvailableWorkers()
        }
        .store(in: &cancallables)
    }
    
    private func updateUserDefaults(forUserWithID uid: String) {
        
        database.child("users/\(uid)")
            .observeSingleEvent(of: .value, with: {[weak self] snapshot  in
                
                guard
                    let value = snapshot.value as? NSDictionary,
                    let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                    let lastName = value[RegistrationKeys.lastName.rawValue] as? String,
                    let phoneNumber = value[RegistrationKeys.phoneNumber.rawValue] as? String,
                    let preferredGender = value[RegistrationKeys.preferredGender.rawValue] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(uid, forKey: "id")
                    UserDefaults.standard.set(firstName, forKey: "firstName")
                    UserDefaults.standard.set(lastName, forKey: "lastName")
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                    UserDefaults.standard.set(preferredGender, forKey: "preferredGender")
                    
                    print("DEBUG: SessionManager - user default saved successfully")
                }
                
                guard let addressbookSnapshot = value["addresses"] as? [[String:Any]] else{
                    return
                }
                let addressbook: [Address] = addressbookSnapshot.compactMap { dictionary in
                    guard let address = dictionary["address"] as? String,
                            let lat = dictionary["lat"] as? Double,
                            let lon = dictionary["lon"] as? Double else {
                          return nil
                      }
                    return Address(label: dictionary["building_name"] as? String,
                                   address: address,
                                   lat: lat,
                                   lon: lon,
                                   buildingName: dictionary["building_name"] as? String,
                                   buzzer: dictionary["buzzer"] as? String,
                                   instruction: dictionary["instruction"] as? String)
                }
                print("DEBUG: SessionManager - addressbook updated successfully")
                self?.addressBook = addressbook
            })
    }
    
    private func startListeningForAvailableWorkers(){
        database.child("aactive").observe(.value, with: { [weak self]snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                return
            }
            
            let activeTherapist: [Therapist] = value.compactMap({ dictionary in
                guard let id = dictionary["id"] as? String,
                      let gender = dictionary["gender"] as? String,
                      let lat = dictionary["lat"] as? Double,
                      let lon = dictionary["lon"] as? Double else {
                    return nil
                }
                
                return Therapist(id: id,gender: gender, lat: lat, lon: lon)
            })
            
            print("DEBUG: SessionManager - Workers DB updated successfully")
            self?.onlineWorkers = activeTherapist
        })
    }
}

