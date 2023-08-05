//
//  MatchMakingView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-24.
//

import SwiftUI

struct MatchMakingView: View {
    @StateObject private var vm = MatchingViewModel()
    @Binding private var viewState: ViewState
    @Binding private var withDelay: Bool
    @Binding private var delayedTime:Int
    @State private var colorOne = #colorLiteral(red: 1, green: 0.5781051517,blue: 0,alpha: 1)
    @State private var colorTwo = #colorLiteral(red: 0.4513868093,green: 0.9930960536,blue: 1, alpha: 1)
    
    
    let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    init(viewState: Binding<ViewState>,
         withDelay: Binding<Bool>,
         delayedTime: Binding<Int>){
        self._viewState = viewState
        self._withDelay = withDelay
        self._delayedTime = delayedTime
    }
    var body: some View {
        VStack(alignment: .center){
            VStack(alignment: .leading){
                HStack{
                    Button {
                        vm.cancelReq()
                    } label: {
                        Spacer()
                        Text("cancel")
                            .cornerRadius(10)
                            .foregroundColor(Color(.systemBlue))
                    }
                }
                Divider()
            }
            ZStack (alignment: .center){
                Rectangle()
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .opacity(0)
                    Breath(vm: vm)
            }
            VStack(alignment: .center) {
                Text(vm.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                    .foregroundColor(vm.change ?
                                     Color(colorOne) :
                                        Color(colorTwo))
                Text(vm.headline)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(vm.change ?
                                     Color(colorOne) :
                                        Color(colorTwo))
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
            }
            .animation(.easeInOut(duration: 2))
            Spacer()
            if vm.isShowingSlider {
                CustomSlidere(vm: vm)
            }
            
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .onReceive(vm.$status) { status in
            if status == "accepted" {
                withAnimation(.spring()) {
                    viewState = .onTheRoad
                    withDelay = true
                    delayedTime = 0
                }
            }
            if status == "pushing" {
                withAnimation {
                    vm.isShowingSlider = true
                }
            }
            if status == "canceled" {
                withAnimation(.spring()) {
                    viewState = .noInput
                    withDelay = true
                    delayedTime = 0
                }
            }
        }
        .onReceive(vm.$isCanceled){ isCanceled in
            if (isCanceled) {
                withAnimation(.spring()) {
                    viewState = .orderDetails
                    withDelay = true
                    delayedTime = 0
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 4,
                                 repeats: true) { _ in
                withAnimation(.easeInOut(duration: 2)) {
                    vm.change.toggle()
                }
            }.fire()
        }
    }
}

struct MatchMakingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchMakingView(viewState: .constant(.lookingForTherapist),
                        withDelay: .constant(true),
                        delayedTime: .constant(0))
    }
}
