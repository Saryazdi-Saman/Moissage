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
import MapKit

final class SessionManager: ObservableObject {
    let database = Database.database().reference()
    
    @Published var signedIn = false
    @Published var user: User?
    @Published var addressBook = [Address]()
//    @Published var onlineWorkers = [Therapist]()
    @Published var uid : String?
    @Published var invoice = Invoice()
    @Published var userLocation : CLLocationCoordinate2D?
    @Published var selectedAddress : Address?
    @Published var pricing :[String:Int] = ["-":0]
    
    private var cancallables = Set<AnyCancellable>()
    private var addressCancellable: AnyCancellable?
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        
        setupObservations()
//        organizeAddressbook()
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
        handler = Auth.auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                let currentUser = Auth.auth().currentUser
                self.signedIn = currentUser == nil ? false : true
                if let uid = currentUser?.uid {
                    self.database.child("user/client/")
                        .child(uid)
                        .observeSingleEvent(of: .value){[weak self] snapshot in
                            guard let value = snapshot.value as? NSDictionary,
                                  let stripeId = value["stripeId"] as? String,
                                  let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                                  let lastName = value[RegistrationKeys.lastName.rawValue] as? String,
                                  let phoneNumber = value[RegistrationKeys.phoneNumber.rawValue] as? String,
                                  let preferredGender = value[RegistrationKeys.preferredGender.rawValue] as? String,
                                  let email = value[RegistrationKeys.email.rawValue] as? String else {
                                print("DEBUG: SessionManager - data was not complete")
                                return
                            }
                            print("DEBUG: SessionManagar - data is complete, user profile downloded")
                            self?.user = User(uid: uid,
                                              stripeId: stripeId,
                                              firstName: firstName,
                                              lastName: lastName,
                                              email: email,
                                              phoneNumber: phoneNumber,
                                              prefferedGender: preferredGender)
                            self?.invoice.stripeId = stripeId
                            self?.invoice.uid = uid
                            self?.invoice.genderPreference = preferredGender
                            if let addressbookSnapshot = value["addresses"] as? [[String:Any]] {
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
                                //                                self?.addressBook = addressbook
                                self?.organizeAddressbook(addressbook)
                            }
                        }
                    
                }
                self.database.child("store/")
                    .observeSingleEvent(of: .value){[weak self] snapshot in
                        guard let value = snapshot.value as? NSDictionary,
                              let fifteen = value["15 min"] as? Int,
                              let thirty = value["30 min"] as? Int,
                              let ninety = value["90 min"] as? Int,
                              let oneHour = value["60 min"] as? Int,
                              let twoHours = value["120 min"] as? Int else {
                            return
                        }
                        self?.pricing["15 min"] = fifteen
                        self?.pricing["30 min"] = thirty
                        self?.pricing["60 min"] = oneHour
                        self?.pricing["90 min"] = ninety
                        self?.pricing["120 min"] = twoHours
                    }
            }
    }
    
    private func organizeAddressbook(_ addressbook: [Address]){
        addressCancellable = $userLocation
            .sink {[weak self] (location) in
                guard addressbook.count > 0 else {return}
                guard location != nil else {
                    return
                }
                self?.sortAddressBook(addressbook)
                self?.invoice.address = self?.addressBook.first
                self?.addressCancellable?.cancel()
            }
    }
    
//    func startListeningForAvailableWorkers(){
//        guard let uid = user?.uid else{
//            return
//        }
//        database.child("dispatch/client/")
//            .child(uid)
//            .observe(.value, with: { [weak self]snapshot in
//                guard let value = snapshot.value as? [[String: Any]] else{
//                    return
//                }
//                
//                let activeTherapist: [Therapist] = value.compactMap({ dictionary in
//                    guard let id = dictionary["id"] as? String,
//                      let gender = dictionary["gender"] as? String,
//                      let lat = dictionary["lat"] as? Double,
//                      let lon = dictionary["lon"] as? Double,
//                      let name = dictionary["name"] as? String else {
//                    return nil
//                }
//                
//                return Therapist(id: id, name: name,gender: gender, lat: lat, lon: lon)
//            })
//            
//            self?.onlineWorkers = activeTherapist
//        })
//    }
    
    //MARK: - helpers
    
    private func sortAddressBook(_ addressbook: [Address]){
        if let location = self.userLocation {
            let currentLocation = CLLocation(latitude: location.latitude,
                                             longitude: location.longitude)
            
            self.addressBook = addressbook
                .sorted(
                    by: { $0.distance(to: currentLocation)
                        < $1.distance(to: currentLocation) })
            return
        } else {
            return
        }
    }
    
}


// MARK: - Server Networking

//extension SessionManager{
//    func updateAddressbook(withAddress location: Address){
//        guard let uid = uid else {return}
//        let values = [AddressAtributes.label.rawValue: location.label as Any,
//                      AddressAtributes.address.rawValue: location.address,
//                      AddressAtributes.lat.rawValue: location.lat,
//                      AddressAtributes.lon.rawValue: location.lon,
//                      AddressAtributes.buzzer.rawValue: location.buzzer as Any,
//                      AddressAtributes.instruction.rawValue: location.instruction as Any,
//                      AddressAtributes.buildingName.rawValue: location.buildingName as Any] as [String : Any]
//
//        let entryNumber = addressBook?.count ?? 0
//        database.child("users")
//            .child(uid)
//            .child("addresses")
//            .child(String(entryNumber))
//            .updateChildValues(values)
//    }
//    
//    func updateGenderPreference(_ preference : String){
//        guard let uid = uid else {return}
//        let values = [RegistrationKeys.preferredGender.rawValue: preference]
//        database.child("users")
//            .child(uid)
//            .updateChildValues(values)
//    }
//}

