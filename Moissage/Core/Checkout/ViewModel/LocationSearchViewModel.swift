//
//  LocationSearchViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import Foundation
import MapKit
import Combine
import FirebaseDatabase

class LocationSearchViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var cancallables = Set<AnyCancellable>()
    @Published var searchVS : LocationSearchViewState = .noInput
    @Published var addressbook = [Address]()
    {
        didSet {
            invoice.address = addressbook.first
        }
    }
    @Published var invoice = Invoice()
    var newAddress = NewAddressRegistration()
    var addressShouldBeSaved = false
    @Published var onCallWorker : AddressPoint?
    
    @Published var userLocation : CLLocationCoordinate2D?
    let service = SaveAddressImp()
    private var subscriptions = Set<AnyCancellable>()
    
    
    //MARK: - helpers
    func selectNewLocation(_ localSearch: MKLocalSearchCompletion) {
        
        invoice.address = Address(label: nil,
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
            self?.invoice.address?.lat =  coordinate.latitude
            self?.invoice.address?.lon =  coordinate.longitude
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
            invoice.address?.label = newAddress.label
        }
        if !newAddress.buzzer.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            invoice.address?.buzzer = newAddress.buzzer
        }
        if !newAddress.unitNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            invoice.address?.address = newAddress.unitNumber + " - " + invoice.address!.address
        }
        if !newAddress.buildingName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            invoice.address?.buildingName = newAddress.buildingName
        }
        if !newAddress.buzzer.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            invoice.address?.instruction = newAddress.instruction
        }
        
        service.save(with: invoice.address!, at: addressbook.count)
            .sink { res in
            
                switch res {
                case .failure(_):
                    print("DEBUG : LoactionSearchViewModel - Error saving new address to database")
                    break
                default: break
                }
            } receiveValue: { [weak self] in
                
                self?.addressbook.insert((self?.invoice.address!)!, at: 0)
                self?.searchVS = .noInput
            }
            .store(in: &subscriptions)
    }
    
    func uploadInvoice(){
        service.upload(invoice: invoice)
            .sink { res in
                switch res {
                case .failure(_):
                    print("DEBUG : LoactionSearchViewModel - Error uploading invoice")
                    break
                default: break
                }
            } receiveValue: {}
            .store(in: &subscriptions)

    }
    
    func trackAgent(){
        guard let uid = service.uid else {
            return
        }
        Database.database().reference()
            .child("contracts/\(uid)/agent/")
            .observe(.value) {[weak self] snapshot in
                guard let value = snapshot.value as? NSDictionary,
                      let lat = value["lat"] as? Double,
                      let lon = value["lon"] as? Double else {
                    print("DEBUG: LocationSearchVM -service - could not track agent")
                    return
                }
                DispatchQueue.main.async {
                    self?.onCallWorker = AddressPoint(lat: lat, lon: lon)
                }
            }
    }
}
