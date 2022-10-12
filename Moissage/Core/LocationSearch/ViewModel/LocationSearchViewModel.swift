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
    @Published var selectedLocation: String?
    private let searchCompleter = MKLocalSearchCompleter()
    private var service : LocationSearchService

    
    
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
    func selectLocation(_ location: String){
        self.selectedLocation = location
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
