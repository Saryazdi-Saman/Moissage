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

struct RegistrationCredentials {
    
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var preferredGender: String
}

protocol RegistrationService {
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error>
}

enum RegistrationKeys: String {
    case firstName
    case lastName
    case phoneNumber
    case preferredGender
    case email
}

final class RegistrationServiceImpl: RegistrationService {
    
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) { res, error in
                    if let err = error {
                        promise(.failure(err))
                    }
                    else {
                        if let uid = res?.user.uid {
                            let values = [RegistrationKeys.firstName.rawValue: credentials.firstName,
                                          RegistrationKeys.lastName.rawValue: credentials.lastName,
                                          RegistrationKeys.phoneNumber.rawValue: credentials.phoneNumber,
                                          RegistrationKeys.preferredGender.rawValue: credentials.preferredGender,
                                          RegistrationKeys.email.rawValue: credentials.email] as [String : Any]
                            Database
                                .database()
                                .reference()
                                .child("user/client")
                                .child(uid)
                                .updateChildValues(values) { error, ref in
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
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

class CreateCustomerResponse: Decodable {
    let customerID : String
}
