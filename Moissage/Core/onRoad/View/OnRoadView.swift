//
//  OnRoadView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-28.
//

import SwiftUI

struct OnRoadView: View {
    @StateObject private var vm = OnRoadViweModel()
    @State private var showSupport = false
    @State private var showMessages = false
    @Binding private var viewState: ViewState
    @Binding private var withDelay: Bool
    @Binding private var delayedTime:Int
    private let maxWidth = UIScreen.main.bounds.width
    init(viewState: Binding<ViewState>,
         withDelay: Binding<Bool>,
         delayedTime: Binding<Int>){
        self._viewState = viewState
        self._withDelay = withDelay
        self._delayedTime = delayedTime
    }
    var body: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 300)
                .opacity(0.95)
            VStack(alignment: .leading){
                HStack{
                    Text("Therapist on the way")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Button{
                        withAnimation(Animation.easeInOut(duration: 1.0)) {
                            showSupport.toggle()
                        }
                    } label: {
                        Text("need help?")
                    }
                    .offset(y: -10)
                }
                Divider()
                HStack(alignment: .center){
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(.systemGray))
                        .clipShape(Circle())
                        .frame(width: maxWidth*0.25, height: maxWidth*0.25)
                        .shadow(radius: 5)
                        .padding(.trailing)
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(vm.agent?.name ?? "Alexandra")
                            .font(.system(size: 22,
                                          weight: .semibold,
                                          design: .rounded))
                        Divider()
                        Text("ETA - 45min")
                            .font(.system(size: 18,
                                          weight: .medium,
                                          design: .rounded))
                    }
                    Spacer()
                }
                .padding(.top)
                .redacted(reason: vm.isProfileComplete ? [] : .placeholder)
                
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color(.tertiarySystemBackground))
                        .frame(width: maxWidth*0.9, height: 45)
                        .shadow(color: .secondary, radius: 2)
                    Text("Meassage \(vm.agent?.name ?? "") ...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .onTapGesture {
                            if vm.isProfileComplete{
                                withAnimation(Animation.easeInOut(duration: 1.0)){
                                    showMessages.toggle()
                                }
                            }
                        }
                }
                .padding(.vertical)
                .redacted(reason: vm.isProfileComplete ? [] : .placeholder)
            }
            .padding()
            .padding(.top, 10)
        }
        .fullScreenCover(isPresented: $showSupport) {
            SupportView(isShowing: $showSupport)
        }
        .fullScreenCover(isPresented: $showMessages) {
            ChatView(isShowing: $showMessages, to: vm.agent!)
        }
    }
}

struct OnRoadView_Previews: PreviewProvider {
    static var previews: some View {
        OnRoadView(viewState: .constant(.onTheRoad),
                   withDelay: .constant(true),
                   delayedTime: .constant(0))
    }
}
