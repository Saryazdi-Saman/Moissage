//
//  LocationSearchView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject var viewModel : LocationSearchViewModel
    @StateObject var searchHelper = SearchCompletor()
    @State private var showSave = false
    var body: some View {
        VStack{
            HStack{
                if viewModel.viewState == .saveNewAddress{
                    LocationSearchActivationView()
                } else {
                    TextField("select address", text: $searchHelper.queryFragment)
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
                    
                    if searchHelper.viewState == .showSavedAddresses {
                        ForEach(viewModel.userSavedAddresses, id: \.self){
                            result in
                            LocationSearchResultCell(title: result.label ?? "",
                                                     subtitle: result.address)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.viewState = .noInput
                                }
                            }
                        }
                        .transition(.move(edge: .bottom))
                    }
                    
                    if searchHelper.viewState == .userIsTyping {
                        ForEach (searchHelper.results, id: \.self){
                            result in
                            LocationSearchResultCell(title: result.title,
                                                     subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation{
                                    searchHelper.viewState = .saveNewAddress
                                    viewModel.viewState = .saveNewAddress
                                }
                            }
                        }
                    }
                    
                    if viewModel.viewState == .saveNewAddress {
                        SaveNewAddress().transition(.move(edge: .bottom))
                        
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView().environmentObject(LocationSearchViewModel())
    }
}
