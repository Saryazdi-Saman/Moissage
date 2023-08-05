//
//  File.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import Foundation
import CoreLocation

enum MassageType : Int, CaseIterable, Identifiable {
    
    case relaxing
    case therapeutic
    case office
    
    var id: Int { return rawValue}
    
    var title: String{
        switch self{
        case .relaxing: return "Relaxing"
        case .therapeutic: return "Therapeutic"
        case .office: return "Office"
        }
    }
    
    var description: String{
        switch self{
        case .relaxing: return "Release your daily stress"
        case .therapeutic: return "Reduce muscle pain"
        case .office: return "In your office, at your desk"
        }
    }
    
    var imageName: String{
        switch self{
        case .relaxing: return "relaxing"
        case .therapeutic: return "therapeutic"
        case .office: return "office"
        }
    }
}

enum MainService : String, CaseIterable{
    case oneHour = "60 min"
    case nintyMin = "90 min"
    case twoHours = "120 min"
}

enum Extras : String, CaseIterable{
    case none = "-"
    case fifteenMin = "15 min"
    case thirtyMin = "30 min"
}

enum Gender: String, Identifiable, CaseIterable {
    var id: Self { self }
    case male
    case female
    case any
}

enum DatabaseError: Error {
    case failedToFetch
    case failedToFindWorker
    
    public var localizedDescription: String {
        switch self {
        case .failedToFetch:
            return "This means blah failed"
        case .failedToFindWorker:
            return "Did not find a therapist"
            
        }
    }
}

struct Invoice: Codable{
    var stripeId: String = ""
    var uid: String = ""
    var invoiceId: Int = 0
    var total: Int = 0
    var payable: Int = 0
    var items = [Product]()
    var address : Address?
    var genderPreference = "anyone"
}

struct Address: Hashable,Codable{
    
    var label: String?
    var address: String
    var lat: Double
    var lon: Double
    var buildingName: String?
    var buzzer: String?
    var instruction: String?
    var location: CLLocation{
        return CLLocation(latitude: self.lat, longitude: self.lon)
    }
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}

struct AddressPoint {
    var lat: Double
    var lon: Double
    var location: CLLocation{
        return CLLocation(latitude: self.lat, longitude: self.lon)
    }
}
struct Agent {
    let id: String
    let name: String
    var imageUrl :String? = "gs://moissage-a078d.appspot.com/4FDFE1B6-6D44-471E-8520-334859F99878_1_105_c.jpeg"
}


struct Product : Identifiable, Codable{
    var id = UUID()
    let name: String
    let duration: String
}

enum AddressAtributes: String {
    case label
    case address
    case lat
    case lon
    case buildingName
    case buzzer
    case instruction
}

struct User {
    let uid: String
    let stripeId: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let prefferedGender: String
}

enum LocationSearchViewState {
    case noInput
    case showSavedAddresses
    case userIsTyping
    case saveNewAddress
}

struct NewAddressRegistration {
    var unitNumber : String = ""
    var buzzer: String = ""
    var label : String = ""
    var buildingName: String = ""
    var instruction: String = ""
}

struct Message : Identifiable{
    var id = NSUUID().uuidString
    
//    let id: String
    let fromId: String
    let toId : String
    let body : String
    
    let uid : String
    
    var chatPartnerId: String {
        return fromId == uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == uid
    }
    
}
