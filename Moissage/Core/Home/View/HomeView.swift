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
                HStack(alignment: .top){
                    if viewState == .sideMenue{
                        sideMenu()
//                            .animation(.easeOut(duration: 0.65))
                            .transition(.move(edge: .leading))
                            .offset(x: -5, y: 0)
                    }
                    MenuButton(viewState: $viewState)
                        .padding(.horizontal)
                }
            }
            
            if viewState == .noInput {
                MassageTypeSelectionCard(viewState: $viewState,
                                         selectedService: $viewModel.cart.mainService)
//                .animation(.easeOut(duration: 0.65))
                .transition(.move(edge: .bottom))
            } else if viewState == .orderDetails{
                OrderDetailView(viewModel: viewModel)
                    .environmentObject(SessionManager())
//                    .animation(.easeOut(duration: 0.65))
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
