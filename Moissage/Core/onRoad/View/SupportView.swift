//
//  SupportView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-03.
//

import SwiftUI

struct SupportView: View {
    @ObservedObject var vm : OnRoadViweModel
    @Binding var isShowing : Bool
    @State private var showMessages = false
    @State private var showChat = false
    @State var showCancel = false
    init(isShowing: Binding<Bool>, vm: OnRoadViweModel){
        self._isShowing = isShowing
        self.vm = vm
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
                    CancelationView(isShowing: $showCancel, vm: vm)
                        .frame(width:UIScreen.main.bounds.width)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                } else {
                    SupportElements(showCancel: $showCancel, showChat: $showChat)
                        .frame(width:UIScreen.main.bounds.width)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $showChat) {
                ChatView(isShowing: $showChat, to: Agent(id:"support", name: "Support"))
            }
        }
        .onReceive(vm.$isSessionCanceled) { isCanceled in
            if isCanceled {
                withAnimation {
                    isShowing.toggle()
                }
            }
        }
        .padding()
        
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(isShowing: .constant(true), vm: OnRoadViweModel())
    }
}
