//
//  HomeView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = CartViewModel()
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @State private var viewState = ViewState.noInput
    var body: some View {
        ZStack (alignment: .bottom){
            ZStack(alignment: .topLeading) {
                MapViewRepresentable()
                    .ignoresSafeArea()
                MenuButton(viewState: $viewState)
                    .padding(.leading)
            }
            
            if viewState == .noInput {
                MassageTypeSelectionCard(viewState: $viewState,
                                         selectedService: $viewModel.cart.mainService)
                .transition(.move(edge: .bottom))
            } else if viewState == .orderDetails{
                OrderDetailView(viewModel: viewModel)
                    .environmentObject(SessionManager())
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(LocationSearchViewModel())
    }
}
