//
//  RegistrationService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//


import Combine
import Foundation
import Firebase
import FirebaseDatabase

enum Gender: String, Identifiable, CaseIterable {
    var id: Self { self }
    case male
    case female
    case any
}

struct RegistrationCredentials {
    
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var preferredGender: Gender
}

protocol RegistrationService {
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error>
}

enum RegistrationKeys: String {
    case firstName
    case lastName
    case phoneNumber
    case preferredGender
}

final class RegistrationServiceImpl: RegistrationService {
    
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error> {
        
        Deferred {

            Future { promise in
                
                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) { res, error in
                    
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        
                        if let uid = res?.user.uid {
                            
                            let values = [RegistrationKeys.firstName.rawValue: credentials.firstName,
                                          RegistrationKeys.lastName.rawValue: credentials.lastName,
                                          RegistrationKeys.phoneNumber.rawValue: credentials.phoneNumber,
                                          RegistrationKeys.preferredGender.rawValue: credentials.preferredGender.rawValue] as [String : Any]
                            
                            Database
                                .database()
                                .reference()
                                .child("users")
                                .child(uid)
                                .updateChildValues(values) { error, ref in
                                    
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
                                        UserDefaults.standard.set(credentials.firstName, forKey: "firstName")
                                        UserDefaults.standard.set(credentials.lastName, forKey: "lastName")
                                        UserDefaults.standard.set(credentials.phoneNumber, forKey: "phoneNumber")
                                        UserDefaults.standard.set(credentials.preferredGender, forKey: "preferredGender")
                                        promise(.success(()))
                                    }
                                }
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
