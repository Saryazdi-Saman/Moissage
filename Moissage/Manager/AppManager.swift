//
//  AppManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
//import Combine
//import CoreLocation


final class AppManager {
    
//    public static let shared = AppManager()
    
    private let database = Database.database().reference()
    private let currentUser = Auth.auth().currentUser
    private var workerDB = [Therapist]()
    private var workerDBDownloadedSuccessfully = false
    
    init(){
        updateUserDefaults()
    }
    
    private func updateUserDefaults() {
        guard let uid = currentUser?.uid else{return}
        
        database.child("users/\(uid)")
            .observeSingleEvent(of: .value, with: {snapshot  in
                
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
                    
                    print("DEBUG: FROM APP MANAGER: user default saved successfully")
                }
            })
    }
    
    func getSavedAddresses(completion: @escaping (Result<[Address], Error>) -> Void) {
        guard let uid = currentUser?.uid else{return}
        database.child("users/\(uid)/addresses")
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                let addressBook: [Address] = value.compactMap({ dictionary in
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
                })
                
                completion(.success(addressBook))
            })
    }
    
    
    func locateAllactiveTherapist(completion: @escaping (Result<[Therapist], Error>) -> Void) {
        if workerDBDownloadedSuccessfully {
            completion(.success(workerDB))
        } else {
            database.child("aactive").observe(.value, with: { [weak self]snapshot in
                guard let value = snapshot.value as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
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
                
                completion(.success(activeTherapist))
                self?.workerDB = activeTherapist
                self?.workerDBDownloadedSuccessfully = true
            })
        }
    }
    
}


