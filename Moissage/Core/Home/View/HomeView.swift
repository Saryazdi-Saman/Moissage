//
//  HomeView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack (alignment: .bottom){
            ZStack(alignment: .top) {
                MapViewRepresentable()
                    .ignoresSafeArea()
                MenuButton()
                    .padding(.leading)
            }
            
//            if orderState == .noInput {
            MassageTypeSelectionCard(orderState: .constant(.noInput))
                    .transition(.move(edge: .bottom))
//            } else if orderState == .orderDetails{
//                OrderDetailView()
//                    .transition(.move(edge: .bottom))
//            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
