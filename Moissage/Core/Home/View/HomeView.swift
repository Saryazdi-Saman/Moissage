//
//  HomeView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject var cartVM = CartViewModel()
    @StateObject var locationVM = LocationSearchViewModel()
    @EnvironmentObject var manager : SessionManager
    @State private var viewState: ViewState = .noInput
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var withDelay = true
    @State private var delayedTime = 0
    
    var body: some View {
        ZStack(alignment: .bottom){
            ZStack(alignment: .topLeading) {
                MapViewRepresentable(locationVM: locationVM)
                    .ignoresSafeArea()
                HStack(alignment: .top){
                    if viewState == .sideMenue{
                        sideMenu()
                            .transition(.move(edge: .leading))
                            .offset(x: -5, y: 2)
                    }
                    MenuButton(viewState: $viewState,
                               withDelay: $withDelay,
                               delayedTime: $delayedTime)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            ZStack{
                if viewState == .noInput {
                    if !withDelay{
                        MassageTypeSelectionCard(
                            selectedService: $cartVM.mainService,
                            viewState: $viewState,
                            withDelay: $withDelay,
                            delayedTime: $delayedTime)
                        .transition(.move(edge: .bottom))
                    }
                }
                if viewState == .orderDetails{
                    if !withDelay{
                        CartView(cartVM,
                                 viewState: $viewState,
                                 withDelay: $withDelay,
                                 delayedTime: $delayedTime)
                            .transition(.move(edge: .bottom))
                    }
                }
                if viewState == .checkout{
                    if !withDelay{
                        CheckoutView(viewState: $viewState,
                                     viewModel: locationVM,
                                     withDelay: $withDelay,
                                     delayedTime: $delayedTime)
                        .transition(.move(edge: .bottom))
                    }
                }
                if viewState == .lookingForTherapist{
                    if !withDelay{
                        MatchMakingView(viewState: $viewState,
                                        withDelay: $withDelay,
                                        delayedTime: $delayedTime)
                        .transition(.move(edge: .bottom))
                    }
                }
                
                if viewState == .onTheRoad {
                    if !withDelay{
                        OnRoadView(viewState: $viewState,
                                   withDelay: $withDelay,
                                   delayedTime: $delayedTime)
                        .transition(.move(edge: .bottom))
                        .onAppear{
                            locationVM.trackAgent();
                        }
                    }
                }
                
                if viewState == .sessionInProgress{
                    if !withDelay{
//                                            SessionInProgressView()
                    }
                }
                if viewState == .noResponse{
                    if !withDelay{
                        NoResponse().transition(.move(edge: .trailing))
                    }
                }
            }.zIndex(2.0)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                manager.userLocation = location
            }
        }
        .onReceive(manager.$addressBook){ addressbook in
            locationVM.addressbook = addressbook
        }
        .onReceive(manager.$pricing){ pricing in
            cartVM.pricing = pricing
            cartVM.total = pricing["60 min"] ?? 0
        }
        .onReceive(timer) { _ in
            delayedTime += 1
            if withDelay, delayedTime == 7 {
                withAnimation {
                    withDelay.toggle()
                }
                
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(SessionManager())
    }
}
