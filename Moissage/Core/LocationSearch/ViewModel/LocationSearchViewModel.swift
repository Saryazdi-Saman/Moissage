//
//  LocationSearchViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import Foundation
import MapKit
import Combine

class LocationSearchViewModel: ObservableObject {
    
    // MARK: - Properties

    private let manager = SessionManager.shared
    @Published var cartManager = CartManager()
    
    var cancallables = Set<AnyCancellable>()
    @Published var globalVS : ViewState = .noInput
    @Published var viewState : LocationSearchViewState = .noInput
    var addressbook = [Address](){
        didSet {
            selectedLocation = addressbook.first
        }
    }
    @Published var genderPreference = UserDefaults.standard.string(forKey: "preferredGender") ?? "anyone"{
        didSet{
            cartManager.cart.preferredGender = genderPreference
        }
    }
    @Published var workCandidates = [Therapist]()
    @Published var workerDatabase = [Therapist]()
    @Published var selectedLocation :Address?
    var newAddress = NewAddressRegistration()
    var addressShouldBeSaved = false
    @Published var onCallWorker: Therapist?{
        didSet{
            if let onCallWorker = onCallWorker{
                workCandidates = [onCallWorker]
            }
        }
    }
    
    @Published var userLocation : CLLocationCoordinate2D?
    
    init(){
        addAddressbookSubscriber()
        startListeningForActiveMembers()
        filterWorkersForValidCandidates()
    }
    
    
    //MARK: - Subscriptions
    
    private func addAddressbookSubscriber(){
        manager.$addressBook
            .combineLatest($userLocation)
            .sink {[weak self] (savedAddresses, location) in
                guard let addresses = savedAddresses,
                      addresses.count > 0 else {return}
                
                self?.addressbook = addresses
                guard location != nil else {
                    return
                }
                self?.sortAddressBook()
                
            }
            .store(in: &cancallables)
    }
    
    private func startListeningForActiveMembers(){
        manager.$onlineWorkers
            .combineLatest($userLocation)
            .sink {[weak self] onlineMembers, location in
                guard let onlineMembers = onlineMembers,
                      onlineMembers.count > 0 else {return}
                guard let self = self else {return}
                self.workerDatabase = onlineMembers
                guard let location = location else {
                    return
                }
                self.prioritizeWorkers(forLocation: CLLocation(latitude: location.latitude,
                                                                longitude: location.longitude))
            }
            .store(in: &cancallables)
    }
    
    private func filterWorkersForValidCandidates(){
        $workerDatabase
            .combineLatest($genderPreference)
            .sink {[weak self] (workers, gender) in
                
                if gender != "anyone" {
                    self?.workCandidates = workers.filter({$0.gender == gender})
                } else {
                    self?.workCandidates = workers
                }
            }.store(in: &cancallables)
    }
    
    
    //MARK: - helpers
    
    private func sortAddressBook(){
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
    
    func prioritizeWorkers(forLocation location:CLLocation){
        self.workerDatabase = workerDatabase
            .sorted(
                by: { $0.distance(to: location)
                    < $1.distance(to: location) })
    }
    
    
    func selectNewLocation(_ localSearch: MKLocalSearchCompletion) {
        
        selectedLocation = Address(label: nil,
                                   address: localSearch.title.appending(", " + localSearch.subtitle),
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
            self?.prioritizeWorkers(forLocation: CLLocation(latitude: coordinate.latitude,
                                                            longitude: coordinate.longitude))
        }
        
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(", " + localSearch.subtitle)
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
    
    func submitOrder(){
//        manager.test()
        print("submiting check out")
        if addressShouldBeSaved {
            print("address should be saved")
            self.saveNewAddress()
            guard let address = selectedLocation else {return}
            print("selected location was not nill, order is submitted to be saved")
            manager.updateAddressbook(withAddress: address)

        }
        guard workCandidates.count > 0,
            let location = selectedLocation else {
            print("no candidates")
            //             ///// Do Something if noOne is available
            return
        }

        manager.submitOrder(ofCart: cartManager.cart,
                            toCandidates: workCandidates,
                            forLocation: location, completion: { [self]result in
            
            switch result {
            case .success(let worker):
                self.onCallWorker = worker
                self.cancallables.removeAll()
                print("successfully connected a Therapist")
                self.globalVS = .sessionInProgress
                
            case .failure( _ ):
                self.globalVS = .noResponse
            }
            
            
        })
        
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

