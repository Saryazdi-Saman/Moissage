//
//  MenuButton.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct MenuButton: View {
//    @EnvironmentObject var vm : LocationSearchViewModel
    @Binding var viewState: ViewState
    @Binding var withDelay: Bool
    @Binding var delayedTime: Int
    var body: some View {
//        if vm.globalVS != .lookingForTherapist {
        Button {
            withAnimation(.easeOut) {
                withDelay = true
                delayedTime = 0
                actionForState(viewState)
            }
            
        } label: {
            ZStack{
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color:.secondary ,radius: 4)
                        .frame(width: 55, height: 55)
                Image(systemName: imageNameForState(viewState))
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
            }
        
    }
    
    func actionForState(_ state : ViewState){
        switch state {
            
        case .noInput :
            withAnimation {
                viewState = .sideMenue
            }
            
        case .orderDetails:
            withAnimation {
                viewState = .noInput
            }
            
        case .sideMenue:
            withAnimation {
                viewState = .noInput
            }
            
        case .checkout:
            withAnimation {
                viewState = .orderDetails
            }
            
        case .lookingForTherapist:
            withAnimation{
                viewState = .orderDetails
            }
            
        case .noResponse:
            withAnimation{
                viewState = .orderDetails
            }
            
        case .sessionInProgress:
            return
            
        case .onTheRoad, .noneOnline:
            return
            
        case .none:
            return
        }
    }
    
    func imageNameForState( _ state : ViewState) -> String{
        switch state {
        case .none: return "arrow.left"
        case .sideMenue: return "arrow.left"
        case .noInput: return "line.3.horizontal"
        case .orderDetails: return "arrow.left"
        case .checkout: return "arrow.left"
        case .lookingForTherapist: return "arrow.left"
        case .noResponse: return "arrow.left"
        case .sessionInProgress: return "line.3.horizontal"
        case .onTheRoad: return "arrow.left"
        case .noneOnline: return "arrow.left"
        }
    }
    
}

enum ViewState {
    case none
    case noInput
    case orderDetails
    case checkout
    case sideMenue
    case lookingForTherapist
    case onTheRoad
    case noneOnline
    case noResponse
    case sessionInProgress
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(viewState:.constant(.noInput),
                   withDelay: .constant(true), delayedTime: .constant(0))
    }
}
