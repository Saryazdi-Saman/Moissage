//
//  SupportView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-03.
//

import SwiftUI

struct SupportView: View {
    @Binding var isShowing : Bool
    @State var showCancel = false
    init(isShowing: Binding<Bool>){
        self._isShowing = isShowing
    }
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack (alignment: .center){
                HStack{
                    Button {
                        withAnimation {
                            if !showCancel {
                                isShowing.toggle()
                            } else {
                                showCancel.toggle()
                            }
                        }
                    } label: {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    Spacer()
                }
                Text("Need help?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Divider()
                Spacer()
                if showCancel {
                    CancelationView(isShowing: $showCancel)
                        .frame(width:UIScreen.main.bounds.width)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                } else {
                    SupportElements(showCancel: $showCancel)
                        .frame(width:UIScreen.main.bounds.width)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                }
                Spacer()
            }
//            .animation(.spring())
        }
        .padding()
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(isShowing: .constant(true))
    }
}
