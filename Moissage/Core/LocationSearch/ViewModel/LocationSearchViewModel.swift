//
//  LocationSearchViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var viewState : LocationSearchViewState
    @Published var userSavedAddresses = [Address]()
    @Published var results = [MKLocalSearchCompletion]()
    private let searchCompleter = MKLocalSearchCompleter()
    private var service : LocationSearchService
    var addressToGo: String = ""
    var selectedLocation: MKLocalSearchCompletion?
    var newAddress = NewAddress()

    
    
    var queryFragment: String = "" {
        didSet{
            searchCompleter.queryFragment = queryFragment
            if queryFragment.isEmpty {
                viewState = .showSavedAddresses
            } else {
                viewState = .userIsTyping
            }
        }
    }
    
    // MARK: - Lifecycle
    override init(){
        viewState = LocationSearchViewState.noInput
        self.service = LocationSearchService()
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        loadUserSavedLocations()
    }
    
    // MARK: - Helpers
    
    func selectLocation(_ location: MKLocalSearchCompletion){
        
    }
    
    func addNewAddress(_ localSearch: MKLocalSearchCompletion){
        self.addressToGo = localSearch.title.appending(localSearch.subtitle)
        locationSearch(ForLocalSearchCompletion: localSearch) { respons, error in
            if let error = error {
                print("DEBUG: Location search fail with error \(error.localizedDescription)")
                return
            }
            guard let item = respons?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            print("DEBUG: location coordinates are: \(coordinate)")
            self.newAddress.lat = Double(coordinate.latitude)
            self.newAddress.lon = Double(coordinate.longitude)
        }
    }
    
    func locationSearch(ForLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
        
    }
}

// MARK: - Communications with server
extension LocationSearchViewModel{
    
    func loadUserSavedLocations(){
        guard let uid = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        service.getSavedAddresses(for: uid) { [weak self] result in
            switch result{
            case .success(let addresses):
                guard !addresses.isEmpty else {
                    return
                }
                self?.userSavedAddresses = addresses
            case .failure(let error):
                print("failed to fetch saved addresses\(error)")
            }
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        
    }
    
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
