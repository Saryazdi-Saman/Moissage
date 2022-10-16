//
//  MenuButton.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct MenuButton: View {
    @Binding var viewState : ViewState
    var body: some View {
        Button {
            withAnimation(.spring()) {
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
            viewState = ViewState.sideMenue
            
        case .orderDetails:
            viewState = ViewState.noInput
            
        case .sideMenue:
            viewState = ViewState.noInput
        }
    }
    
    func imageNameForState( _ state : ViewState) -> String{
        switch state {
        case .sideMenue: return "arrow.left"
        case .noInput: return "line.3.horizontal"
        case .orderDetails: return "arrow.left"
        }
    }
    
}

enum ViewState {
    case noInput
    case orderDetails
    case sideMenue
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(viewState: .constant(.noInput))
    }
}
