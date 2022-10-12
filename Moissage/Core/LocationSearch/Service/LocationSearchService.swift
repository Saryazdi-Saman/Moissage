//
//  LocationSearchService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import Foundation
import FirebaseDatabase

struct Address : Hashable {
    
    let label: String
    let address: String
    let lat: Double
    let lon: Double
    let buildingName: String?
    let buzzer: String?
    let instruction: String?
}

final class LocationSearchService {
    
    private let database = Database.database().reference()
    
    func getSavedAddresses(for userID: String, completion: @escaping (Result<[Address], Error>)-> Void) {
        database.child("\(userID)/addresses")
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value as? [[String:Any]] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                let addresses: [Address] = value.compactMap { dictionary in
                    guard let address = dictionary["address"] as? String,
                          let label = dictionary["label"] as? String,
                          let lat = dictionary["lat"] as? Double,
                          let lon = dictionary["lon"] as? Double else {
                        return nil
                    }
                    return Address(label: label,
                                   address: address,
                                   lat: lat,
                                   lon: lon,
                                   buildingName: dictionary["building_name"] as? String,
                                   buzzer: dictionary["buzzer"] as? String,
                                   instruction: dictionary["instruction"] as? String)
                }
                completion(.success(addresses))
            })
    }
    
    enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
}
