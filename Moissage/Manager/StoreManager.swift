//
//  StoreManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-12.
//

import Foundation
import MapKit

final class StoreManager: ObservableObject{
    @Published var user: User
    @Published var addressbook: [Address]{
        didSet {
            selectedAddress = addressbook.first
        }
    }
//    @Published var onlineWorkers = [Therapist]()
    @Published var invoice: Invoice
    @Published var selectedAddress : Address?
    
    init(user: User, addressbook: [Address], invoice: Invoice) {
        self.user = user
        self.addressbook = addressbook
        self.invoice = invoice
    }
    
    func sortAddressBook(location: CLLocationCoordinate2D){
        let currentLocation = CLLocation(latitude: location.latitude,
                                         longitude: location.longitude)
        
        self.addressbook = addressbook
            .sorted(
                by: { $0.distance(to: currentLocation)
                    < $1.distance(to: currentLocation) })
        return
    }
}
