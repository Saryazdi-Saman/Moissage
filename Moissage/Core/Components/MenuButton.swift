//
//  MenuButton.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct MenuButton: View {
    @State var orderState = OrderState.noInput
    //        @EnvironmentObject var sessionService : SessionServiceImpl
    var body: some View {
        Button {
            //                withAnimation(.spring()) {
            //                    actionForState(orderState)
            //                }
            
        } label: {
            ZStack{
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color:.secondary ,radius: 4)
                    .frame(width: 55, height: 55)
                Image(systemName: imageNameForState(orderState))
                    .font(.title3)
                    .foregroundColor(.primary)
                    
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    //        func actionForState(_ state : OrderState){
    //            switch state {
    //            case .noInput :
    //
    //                //                sessionService.logout()
    //            case .orderDetails:
    //                orderState = OrderState.noInput
    //            }
    //        }
    
    func imageNameForState( _ state : OrderState) -> String{
        switch state {
        case .noInput: return "line.3.horizontal"
        case .orderDetails: return "arrow.left"
        }
    }
    
}

enum OrderState {
    case noInput
    case orderDetails
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton()
    }
}
