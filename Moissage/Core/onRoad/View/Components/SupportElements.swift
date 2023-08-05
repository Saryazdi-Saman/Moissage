//
//  SupportElements.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-03.
//

import SwiftUI

struct SupportElements: View {
    @Binding var showCancel : Bool
    init(showCancel: Binding<Bool>){
        self._showCancel = showCancel
    }
    var body: some View {
        VStack{
            Button{
                withAnimation{
                    showCancel.toggle()
                }
            } label: {
                Text("cancel my booking")
            }
            .padding(.bottom, 50)
            Button{} label: {
                Text("chat with support")
            }
            .padding(.bottom, 100)
            
        }
    }
}

struct SupportElements_Previews: PreviewProvider {
    static var previews: some View {
        SupportElements(showCancel: .constant(false))
    }
}
