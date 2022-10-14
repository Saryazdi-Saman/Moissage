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

enum MainServiceDuration : String, CaseIterable{
    case oneHour = "60 min"
    case nintyMin = "90 min"
    case twoHours = "120 min"
    
    var price : Int {
        switch self {
        case .oneHour: return 100
        case .nintyMin: return 140
        case .twoHours: return 185
            
        }
    }
}

enum ExtraHeadMassage : String, CaseIterable{
    case none = "-"
    case fifteenMin = "15 min"
    case thirtyMin = "30 min"
    
    var price : Int {
        switch self {
        case .none: return 0
        case .fifteenMin: return 25
        case .thirtyMin: return 50
        }
    }
}

enum ExtraFootMassage : String, CaseIterable{
    case none = "-"
    case fifteenMin = "15 min"
    case thirtyMin = "30 min"
    
    var price : Int {
        switch self {
        case .none: return 0
        case .fifteenMin: return 25
        case .thirtyMin: return 50
        }
    }
}

enum PreferredGender: String, CaseIterable {
    case male
    case female
    case anyone
}

struct Address: Hashable{
    
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

struct Therapist {
    let id: String
    let gender: String
    var lat: Double
    var lon: Double
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
