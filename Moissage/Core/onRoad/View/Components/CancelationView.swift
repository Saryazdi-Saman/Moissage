//
//  CancelationView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-03.
//

import SwiftUI

struct CancelationView: View {
    @Binding var isShowing : Bool
    init(isShowing: Binding<Bool>){
        self._isShowing = isShowing
    }
    var body: some View {
        VStack{
            Text("One of our therapists has already started preparing for your treatment.\nThere will be a 25% cancelation fee if you decide to cancel your booking at this point. \n\nDo you want to continue?")
                .padding()
//            Text("Please note that you will be charged a fee, because one of our therapists has already confirmed your booking and started preparing for you. The cancelation fee is 20% of your invoice. ")
//                .padding()
            Button{
                withAnimation{
                    isShowing.toggle()
                }
            } label: {
                Text("I changed my mind")
                    .fontWeight(.medium)
            }.padding()
            Button{
                withAnimation{
                }
            } label: {
                Text("Accept fees and cancel my booking")
            }
            .foregroundColor(Color(.systemRed))
            .padding()
        }
    }
}

struct CancelationView_Previews: PreviewProvider {
    static var previews: some View {
        CancelationView(isShowing: .constant(true))
    }
}
