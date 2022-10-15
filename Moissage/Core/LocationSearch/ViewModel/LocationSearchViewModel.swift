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
    @Published var preference = UserDefaults.standard.string(forKey: "preferredGender") ?? "anyone"
    var workCandidates : [Therapist] {
        if preference == "anyone" {
            return workerDatabase
        } else {
            return workerDatabase.filter({$0.gender == preference})
        }
    }
    private var workerDatabase = [Therapist]()
    var selectedLocation :Address? {
        didSet{
            sortWorkersDB()
        }
    }
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
        if let address = self.selectedLocation {
            let serviceAddressLocation = CLLocation(latitude: address.location.coordinate.latitude,
                                                    longitude: address.location.coordinate.longitude)
            self.workerDatabase = workerDatabase
                .sorted(
                    by: { $0.distance(to: serviceAddressLocation)
                        < $1.distance(to: serviceAddressLocation) })
            return
        } else {
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
    }
    
    func selectNewLocation(_ localSearch: MKLocalSearchCompletion) {
        
        selectedLocation = Address(label: nil,
                                   address: localSearch.title.appending(localSearch.subtitle),
                                   lat: 0,
                                   lon: 0,
                                   buildingName: nil,
                                   buzzer: nil,
                                   instruction: nil)
        locationSearch(forLocalSearchCompletion: localSearch) {[weak self] result, error in
            if let error = error {
                print("DEBUG: LocationViewModel - location coordinate search failed: \(error.localizedDescription)")
                return
            }
            guard let item = result?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            print("DEBUG: LocationViewModel - successfully retrieved selected location's coordinate: \(coordinate)")
            self?.selectedLocation?.lat =  coordinate.latitude
            self?.selectedLocation?.lon =  coordinate.longitude
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
