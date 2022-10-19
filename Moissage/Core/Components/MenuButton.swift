//
//  MenuButton.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct MenuButton: View {
//    @Binding var searchVS : ViewState
    @EnvironmentObject var vm : LocationSearchViewModel
    var body: some View {
//        if vm.globalVS != .lookingForTherapist {
        Button {
            withAnimation(.spring()) {
                actionForState(vm.globalVS)
            }
            
        } label: {
            ZStack{
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color:.secondary ,radius: 4)
                        .frame(width: 55, height: 55)
                Image(systemName: imageNameForState(vm.globalVS))
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
            }
//        }
        
    }
    
    func actionForState(_ state : ViewState){
        switch state {
            
        case .noInput :
            vm.globalVS = ViewState.sideMenue
            
        case .orderDetails:
            vm.globalVS = ViewState.noInput
            
        case .sideMenue:
            vm.globalVS = ViewState.noInput
            
        case .lookingForTherapist:
            vm.globalVS = ViewState.orderDetails
            vm.cancelOrder()
            
        case .noResponse:
            vm.globalVS = ViewState.orderDetails
            vm.cancelOrder()
            
        case .sessionInProgress:
            return
        }
    }
    
    func imageNameForState( _ state : ViewState) -> String{
        switch state {
        case .sideMenue: return "arrow.left"
        case .noInput: return "line.3.horizontal"
        case .orderDetails: return "arrow.left"
        case .lookingForTherapist: return "arrow.left"
        case .noResponse: return "arrow.left"
        case .sessionInProgress: return "line.3.horizontal"
        }
    }
    
}

enum ViewState {
    case noInput
    case orderDetails
    case sideMenue
    case lookingForTherapist
    case noResponse
    case sessionInProgress
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton().environmentObject(LocationSearchViewModel())
    }
}
