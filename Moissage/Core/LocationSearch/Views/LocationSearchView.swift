//
//  LocationSearchView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchView: View {
    @ObservedObject var vm: LocationSearchViewModel
    @StateObject var searchHelper = SearchCompletor()
    @State private var showSave = false
    
    init(viewModel vm: LocationSearchViewModel){
        self.vm = vm
    }
    var body: some View {
        VStack{
            HStack{
                if vm.searchVS == .saveNewAddress{
                    LocationSearchActivationView(viewModel: vm)
                } else {
                    TextField("Search for address", text: $searchHelper.queryFragment)
                        .padding(.leading, 8)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray4))
                        .cornerRadius(12)
                }
            }
            .padding(.bottom)
            ScrollView{
                VStack(alignment: .leading) {
                    
                    if searchHelper.viewState == .showSavedAddresses{
                        ForEach(vm.addressbook, id: \.self){
                            result in
                            LocationSearchResultCell(title: result.label,
                                                     subtitle: result.address)
                            .onTapGesture {
                                vm.invoice.address = result
                                withAnimation(.spring()){
                                    vm.searchVS = .noInput
                                }
                            }
                        }
                    }
                    
                    if searchHelper.viewState == .userIsTyping {
                        ForEach (searchHelper.results, id: \.self){
                            result in
                            LocationSearchResultCell(title: result.title,
                                                     subtitle: result.subtitle)
                            .onTapGesture {
                                vm.selectNewLocation(result)
                                vm.addressShouldBeSaved = true
                                searchHelper.viewState = .saveNewAddress
                                vm.searchVS = .saveNewAddress
                                
                            }
                        }
                    }
                    
                    if vm.searchVS == .saveNewAddress {
                        SaveNewAddress(viewModel: vm)
                        
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(viewModel: LocationSearchViewModel())
    }
}
