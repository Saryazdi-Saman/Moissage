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
        startUpdatingDatabase()
    }
    
    deinit {
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
        print("deinit SessionServiceImpl")
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func startUpdatingDatabase(){
        $uid.sink { [weak self] id in
            guard let uid = id else { return }
            guard let self = self else {return}
                self.updateUserDefaults(forUserWithID: uid)
                self.startListeningForAvailableWorkers()
        }
        .store(in: &cancallables)
    }
    
    func stopDatabaseObservations(){
        cancallables.removeAll()
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
    
    
    
    private func updateUserDefaults(forUserWithID uid: String) {
        
        database.child("users/\(uid)")
            .observeSingleEvent(of: .value, with: {[weak self] snapshot  in
                
                guard let value = snapshot.value as? NSDictionary else {return}
                    let firstName = value[RegistrationKeys.firstName.rawValue] as? String
                    let lastName = value[RegistrationKeys.lastName.rawValue] as? String
                    let phoneNumber = value[RegistrationKeys.phoneNumber.rawValue] as? String
                    let preferredGender = value[RegistrationKeys.preferredGender.rawValue] as? String
                    let email = value[RegistrationKeys.email.rawValue] as? String
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(uid, forKey: "id")
                    UserDefaults.standard.set(firstName, forKey: "firstName")
                    UserDefaults.standard.set(lastName, forKey: "lastName")
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                    UserDefaults.standard.set(preferredGender, forKey: "preferredGender")
                    UserDefaults.standard.set(email, forKey: "email")
                    
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
                    return Address(label: dictionary["label"] as? String,
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
    
    func startListeningForAvailableWorkers(){
        database.child("aactive").observe(.value, with: { [weak self]snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                return
            }
            
            let activeTherapist: [Therapist] = value.compactMap({ dictionary in
                guard let id = dictionary["id"] as? String,
                      let gender = dictionary["gender"] as? String,
                      let lat = dictionary["lat"] as? Double,
                      let lon = dictionary["lon"] as? Double,
                      let name = dictionary["name"] as? String else {
                    return nil
                }
                
                return Therapist(id: id, name: name,gender: gender, lat: lat, lon: lon)
            })
            
            self?.onlineWorkers = activeTherapist
        })
    }
}

// MARK: - Uploading to server

extension SessionManager{
    
    func updateAddressbook(withAddress location: Address){
        guard let uid = uid else {return}
        let values = [AddressAtributes.label.rawValue: location.label as Any,
                      AddressAtributes.address.rawValue: location.address,
                      AddressAtributes.lat.rawValue: location.lat,
                      AddressAtributes.lon.rawValue: location.lon,
                      AddressAtributes.buzzer.rawValue: location.buzzer as Any,
                      AddressAtributes.instruction.rawValue: location.instruction as Any,
                      AddressAtributes.buildingName.rawValue: location.buildingName as Any] as [String : Any]

        let entryNumber = addressBook?.count ?? 0
        database.child("users")
            .child(uid)
            .child("addresses")
            .child(String(entryNumber))
            .updateChildValues(values)
    }
    
    func updateGenderPreference(_ preference : String){
        guard let uid = uid else {return}
        let values = [RegistrationKeys.preferredGender.rawValue: preference]
        database.child("users")
            .child(uid)
            .updateChildValues(values)
    }
}

