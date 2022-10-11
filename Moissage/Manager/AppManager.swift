//
//  AppManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import Foundation
import FirebaseDatabase
import Combine
import CoreLocation

struct Therapist {
    let id: String
    let gender : String
    var location : CLLocation
    var distance : CLLocationDistance
    
}

final class AppManager {
    
    public static let shared = AppManager()
    
    private let database = Database.database().reference()
    
    public enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
    
    public func locateNearbyTherapist(at location: CLLocation, completion: @escaping (Result<[Therapist], Error>) -> Void) {
        database.child("aactive").observe(.value, with: { snapshot in
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

                   let workerLocation = CLLocation(latitude: lat, longitude: lon)
                   let distance = workerLocation.distance(from: location)
                   return Therapist(id: id,gender: gender, location: location, distance: distance)
               })

               completion(.success(activeTherapist))
           })
       }
}
