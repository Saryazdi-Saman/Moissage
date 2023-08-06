//
//  SupportElements.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-03.
//

import SwiftUI

struct SupportElements: View {
    @Binding var showCancel : Bool
    @Binding var showChat : Bool
    init(showCancel: Binding<Bool>, showChat: Binding<Bool>){
        self._showCancel = showCancel
        self._showChat = showChat
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
            Button{
                withAnimation{
                    showChat.toggle()
                }
            } label: {
                Text("chat with support")
            }
            .padding(.bottom, 100)
            
        }
    }
}

struct SupportElements_Previews: PreviewProvider {
    static var previews: some View {
        SupportElements(showCancel: .constant(false), showChat: .constant(false))
    }
}
