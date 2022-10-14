//
//  SearchCompletor.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-13.
//

import Foundation
import MapKit

class SearchCompletor: NSObject, ObservableObject{
    
    @Published var viewState : LocationSearchViewState
    @Published var results = [MKLocalSearchCompletion]()
    private let searchCompleter = MKLocalSearchCompleter()
    
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
    override init(){
        viewState = LocationSearchViewState.showSavedAddresses
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
    }
    
    func locationSearch(ForLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
        
    }
}

extension SearchCompletor: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        
    }
    
}
