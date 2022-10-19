//
//  OrderInProgress.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-15.
//

//import SwiftUI
//
//struct OrderInProgress: View {
//    @EnvironmentObject var vm: LocationSearchViewModel
//    var body: some View {
//        if vm.globalVS == .lookingForTherapist{
//            withAnimation {
//                LoadingView()
//                    .transition(.move(edge: .bottom))
//            }
//            
//        }
//        if vm.globalVS == .sessionInProgress{
//            withAnimation {
//                SessionInProgressView()
//                    .transition(.move(edge: .bottom))
//            }
//        }
//    }
//}
//
//struct OrderInProgress_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderInProgress().environmentObject(LocationSearchViewModel())
//    }
//}
