//
//  SaveAddressService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-13.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine

protocol SaveAddressService {
    func save(with address: Address, at index: Int) -> AnyPublisher<Void, Error>
}

final class SaveAddressImp: SaveAddressService{
    let uid = Auth.auth().currentUser?.uid
    func save(with address: Address, at index: Int) -> AnyPublisher<Void, Error> {
        Deferred {
            Future {[weak self] promise in
                let values = [AddressAtributes.label.rawValue: address.label as Any,
                              AddressAtributes.address.rawValue: address.address,
                              AddressAtributes.lat.rawValue: address.lat,
                              AddressAtributes.lon.rawValue: address.lon,
                              AddressAtributes.buzzer.rawValue: address.buzzer as Any,
                              AddressAtributes.instruction.rawValue: address.instruction as Any,
                              AddressAtributes.buildingName.rawValue: address.buildingName as Any] as [String : Any]
        
                if let uid = self?.uid {
                    Database.database().reference()
                        .child("user/client/\(uid)/addresses/\(index)/")
                        .setValue(values) { error, _ in
                            if let err = error {
                                promise(.failure(err))
                            } else {
                                promise(.success(()))
                            }
                        }
                }
                
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func upload(invoice: Invoice) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                
                let address = ["address": invoice.address!.address as String,
                               "lat": invoice.address!.lat as Double,
                               "lon": invoice.address!.lon as Double,
                               "buildingName": invoice.address?.buildingName as Any,
                               "buzzer": invoice.address?.buzzer as Any,
                               "instruction": invoice.address?.instruction as Any] as [String: Any]
                Database.database().reference()
                    .child("invoices/\(invoice.invoiceId)/address/")
                    .setValue(address) { error, _ in
                        if let err = error {
                            promise(.failure(err))
                        }
                    }
                Database.database().reference()
                    .child("invoices/\(invoice.invoiceId)/gender/")
                    .setValue(invoice.genderPreference) { error, _ in
                        if let err = error {
                            promise(.failure(err))
                        }
                    }
                Database.database().reference()
                    .child("user/client/\(invoice.uid)/preferredGender/")
                    .setValue(invoice.genderPreference) { error, _ in
                        if let err = error {
                            promise(.failure(err))
                        }else {
                            promise(.success(()))
                        }
                    }
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}

