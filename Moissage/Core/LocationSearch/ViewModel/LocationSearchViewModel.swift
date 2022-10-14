//
//  LocationSearchViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import Foundation
import MapKit

class LocationSearchViewModel: ObservableObject {
    
    // MARK: - Properties
    private var manager = AppManager()
    
    @Published var viewState : LocationSearchViewState = .noInput
    @Published var userSavedAddresses = [Address]()
//    @Published var selectedLocation : Address
    
    private var workers = [Therapist]()
//    private var downloadedAddresses : Bool{
//        if SessionManager.shared.addressBook != nil {
//            userSavedAddresses = SessionManager.shared.addressBook!
//            return true
//        } else {
//            return false
//        }
//    }
    
    var newAddress = NewAddress()
    var userLocation : CLLocationCoordinate2D?{
        didSet{
            sortAddressBook(userLocation!)
        }
    }
    
//    // MARK: - Lifecycle
//    override init(){
//        super.init()
//        startListeningForWorkersAvailable()
//        loadUserSavedLocations()
//
//    }
    
    
    
    // MARK: - Helpers
    
    func selectLocation(_ location: MKLocalSearchCompletion){
        
    }
    
    func sortAddressBook(_ userLocation: CLLocationCoordinate2D){
//        guard let savedAddresses = SessionManager.shared.addressBook else {
//            return
//        }
    }
}

// MARK: - Communications with server
extension LocationSearchViewModel{
 
//    private func startListeningForWorkersAvailable(){
//        AppManager.shared.locateAllTherapist(){ [weak self] result in
//            switch result {
//            case .success(let workers):
//                guard !workers.isEmpty else {return}
//                self?.workers = workers
//            case .failure(let error):
//                print("DEBUG: failed to fetch worker's Location \(error)")
//
//            }
//
//        }
//    }
}

enum LocationSearchViewState {
    case noInput
    case showSavedAddresses
    case userIsTyping
    case saveNewAddress
}

struct NewAddress {
    var saveNewAddress: Bool = false
    var address : String = ""
    var unitNumber : String = ""
    var buzzer: String = ""
    var label : String = ""
    var buildingName: String = ""
    var instruction: String = ""
    var lat: Double = 0
    var lon: Double = 0
}
