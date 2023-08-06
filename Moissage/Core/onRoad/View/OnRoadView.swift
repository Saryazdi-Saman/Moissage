//
//  OnRoadView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-28.
//

import SwiftUI

struct OnRoadView: View {
    @StateObject private var vm = OnRoadViweModel()
    @ObservedObject var locationVM : LocationSearchViewModel
    @State private var showSupport = false
    @State private var showMessages = false
    @Binding private var viewState: ViewState
    @Binding private var withDelay: Bool
    @Binding private var delayedTime:Int
    private let maxWidth = UIScreen.main.bounds.width
    init(locationVM: LocationSearchViewModel,
         viewState: Binding<ViewState>,
         withDelay: Binding<Bool>,
         delayedTime: Binding<Int>){
        self._viewState = viewState
        self._withDelay = withDelay
        self._delayedTime = delayedTime
        self.locationVM = locationVM
    }
    var body: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 300)
                .opacity(0.95)
            VStack(alignment: .leading){
                HStack(alignment: .center){
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
                            .fontWeight(.medium)
                    }
                }
                .padding(.bottom)
                Divider()
                HStack(alignment: .center){
                    ZStack{
                        if vm.profilePhoto == nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(.systemGray))
                                .frame(width: maxWidth*0.25, height: maxWidth*0.25)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .padding(.trailing)
                        } else {
                            Image(uiImage: vm.profilePhoto!)
                                .resizable()
                                .frame(width: maxWidth*0.25, height: maxWidth*0.25)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .padding(.trailing)
                        }
                    }
                    .redacted(reason: vm.isPhotoReady ? [] : .placeholder)
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(vm.agent?.name ?? "failed to load name")
                            .font(.system(size: 22,
                                          weight: .semibold,
                                          design: .rounded))
                            .redacted(reason: vm.isProfileComplete ? [] : .placeholder)
                        Divider()
                        Text(vm.isProfileComplete ?
                             "preparing..." : "loading...")
                            .font(.system(size: 18,
                                          weight: .medium,
                                          design: .rounded))
                            .padding(.bottom, 1)
                        Text("ETA - 45min")
                            .font(.system(size: 16,
                                          weight: .medium,
                                          design: .rounded))
                    }
                    Spacer()
                }
                .padding(.top)
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color(.tertiarySystemBackground))
                        .frame(width: maxWidth*0.9, height: 45)
                        .shadow(color: .secondary, radius: 2)
                    Text("Meassage \(vm.agent?.name ?? "") ...")
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                        .opacity(0.6)
                        .padding(.horizontal)
                        .onTapGesture {
                            if vm.isProfileComplete {
                                withAnimation(Animation.easeInOut(duration: 1.0)){
                                    showMessages.toggle()
                                }
                            }
                        }
                        .redacted(reason: vm.isProfileComplete ? [] : .placeholder)
                }
                .padding(.vertical)
            }
            .padding()
            .padding(.top, 10)
        }
        .fullScreenCover(isPresented: $showSupport) {
            SupportView(isShowing: $showSupport, vm: vm)
        }
        .fullScreenCover(isPresented: $showMessages) {
            ChatView(isShowing: $showMessages, to: vm.agent!)
        }
        .onReceive(vm.$isSessionCanceled) { isCanceled in
            if isCanceled {
                withAnimation {
                    viewState = .noInput
                }
            }
        }
        .onReceive(vm.$cancelRequested) { isRequested in
            if isRequested {
                locationVM.stopTracking()
                vm.cancelSession()
                showSupport = false
            }
        }
    }
}

struct OnRoadView_Previews: PreviewProvider {
    static var previews: some View {
        OnRoadView(locationVM: LocationSearchViewModel(),
                   viewState: .constant(.onTheRoad),
                   withDelay: .constant(true),
                   delayedTime: .constant(0))
    }
}
