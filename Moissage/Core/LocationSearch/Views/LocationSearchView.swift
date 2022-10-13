//
//  LocationSearchView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject var viewModel : LocationSearchViewModel
    @State private var showSave = false
    var body: some View {
        VStack{
            HStack{
                if viewModel.viewState == .saveNewAddress{
                    LocationSearchActivationView()
                } else {
                    TextField("select address", text: $viewModel.queryFragment)
                        .padding(.leading, 8)
                        .frame(height: 44)
                        .background(Color(.systemGray4))
                }
            }
            .padding(.bottom)
            ScrollView{
                VStack(alignment: .leading) {
                    
                    if viewModel.viewState == .showSavedAddresses {
                        ForEach(viewModel.userSavedAddresses, id: \.self){
                            result in
                            LocationSearchResultCell(title: result.label,
                                                     subtitle: result.address)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.viewState = .noInput
                                }
                            }
                        }
                        .transition(.move(edge: .bottom))
                    }
                    
                    if viewModel.viewState == .userIsTyping {
                        ForEach (viewModel.results, id: \.self){
                            result in
                            LocationSearchResultCell(title: result.title,
                                                     subtitle: result.subtitle)
                            .onTapGesture {
                                viewModel.addNewAddress(result)
                                withAnimation{
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
