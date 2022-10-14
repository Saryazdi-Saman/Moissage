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
    @Published var addressbook = [Address](){
        didSet {
            selectedLocation = addressbook.first
        }
    }
    
    @Published var workerDatabase = [Therapist]()
    @Published var selectedLocation :Address?
    var newAddress = NewAddressRegistration()
    var addressShouldBeSaved = false
    
    var userLocation : CLLocationCoordinate2D?{
        didSet{
            startListeningForActiveMembers()
        }
    }
    
    init(){
        startListeningForAddresses()
    }
    
    private func startListeningForAddresses(){
        manager.getSavedAddresses { [weak self] result in
            switch result{
            case .success(let addressbook):
                print("DEBUG: LocationSearchViewModel - successfully got addressbook")
                guard !addressbook.isEmpty else {
                    print("DEBUG: LocationSearchViewModel - addressbook was empty")
                    return
                }
                self?.addressbook = addressbook
                
            case .failure(let error):
                print("failed to get saved addresses: \(error)")
            }
        }
    }
    
    private func startListeningForActiveMembers(){
        manager.locateAllactiveTherapist { [weak self] result in
            switch result{
            case .success(let workerDatabase):
//                print("DEBUG: LocationSearchViewModel - successfully got online workers, total members: \(workerDatabase.count)")
                guard !workerDatabase.isEmpty else {
//                    print("DEBUG: LocationSearchViewModel - workers was empty")
                    return
                }
                self?.workerDatabase = workerDatabase
                self?.sortWorkersDB()
                
            case .failure(let error):
                print("failed to get online workers: \(error)")
            }
        }
    }
    
    func sortAddressBook(){
        if let location = self.userLocation {
            let currentLocation = CLLocation(latitude: location.latitude,
                                             longitude: location.longitude)
            
            self.addressbook = addressbook
                .sorted(
                    by: { $0.distance(to: currentLocation)
                        < $1.distance(to: currentLocation) })
            return
        } else {
            return
        }
    }
    
    private func sortWorkersDB(){
        if let location = self.userLocation {
            let currentLocation = CLLocation(latitude: location.latitude,
                                             longitude: location.longitude)
            
            self.workerDatabase = workerDatabase
                .sorted(
                    by: { $0.distance(to: currentLocation)
                        < $1.distance(to: currentLocation) })
            return
        } else {
            return
        }
    }
    
    func selectNewLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) {[weak self] result, error in
            if let error = error {
                print("DEBUG: LocationViewModel - location coordinate search failed: \(error.localizedDescription)")
                return
            }
            guard let item = result?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            print("DEBUG: LocationViewModel - successfully retrieved selected location's coordinate: \(coordinate)")
            self?.selectedLocation = Address(label: nil,
                                       address: localSearch.title.appending(localSearch.subtitle),
                                       lat: coordinate.latitude,
                                       lon: coordinate.longitude,
                                       buildingName: nil,
                                       buzzer: nil,
                                       instruction: nil)
        }
        
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func saveNewAddress(){
        if !newAddress.label.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            selectedLocation?.label = newAddress.label
        }
        if !newAddress.buzzer.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            selectedLocation?.buzzer = newAddress.buzzer
        }
        if !newAddress.unitNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            selectedLocation?.address = newAddress.unitNumber + " - " + selectedLocation!.address
        }
        if !newAddress.buildingName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            selectedLocation?.buildingName = newAddress.buildingName
        }
        if !newAddress.buzzer.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            selectedLocation?.instruction = newAddress.instruction
        }
    }



//    @Published var selectedLocation : Address
    
//    private var downloadedAddresses : Bool{
//        if SessionManager.shared.addressBook != nil {
//            userSavedAddresses = SessionManager.shared.addressBook!
//            return true
//        } else {
//            return false
//        }
//    }
    
    
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

struct NewAddressRegistration {
    var unitNumber : String = ""
    var buzzer: String = ""
    var label : String = ""
    var buildingName: String = ""
    var instruction: String = ""
}
