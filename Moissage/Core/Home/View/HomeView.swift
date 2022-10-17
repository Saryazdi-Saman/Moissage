//
//  HomeView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct HomeView: View {
//    @StateObject var viewModel = CartViewModel()
    @EnvironmentObject var viewModel : LocationSearchViewModel
    
    var body: some View {
        ZStack (alignment: .bottom){
            ZStack(alignment: .topLeading) {
                MapViewRepresentable()
                    .ignoresSafeArea()
                HStack(alignment: .top){
                    if viewModel.globalVS == .sideMenue{
                        sideMenu()
                            .transition(.move(edge: .leading))
                            .offset(x: -5, y: 2)
                    }
                    MenuButton()
                        .padding(.horizontal)
                    Spacer()
                }
            }
            
            if viewModel.globalVS == .noInput {
                MassageTypeSelectionCard()
                .transition(.move(edge: .bottom))
            }
            if viewModel.globalVS == .orderDetails{
                OrderDetailView()
                    .environmentObject(SessionManager())
                    .transition(.move(edge: .bottom))
            }
            if viewModel.globalVS == .lookingForTherapist{
                OrderInProgress()
                    .transition(.move(edge: .bottom))
            }
            if viewModel.globalVS == .sessionInProgress{
                SessionInProgressView()
                    .transition(.move(edge: .bottom)).animation(.spring())
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                viewModel.userLocation = location
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(LocationSearchViewModel())
    }
}
