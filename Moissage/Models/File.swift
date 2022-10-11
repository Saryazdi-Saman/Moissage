//
//  File.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import Foundation

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
    
    var prices : [String : Double] {
        switch self{
        default : return ["60 min"  : 100.00,
                          "90 min"  : 145.00,
                          "120 min" : 190.00]
        }
    }
    
}
