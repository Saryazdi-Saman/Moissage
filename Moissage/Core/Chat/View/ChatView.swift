//
//  ChatView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-04.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()
    @Binding var isShowing : Bool
    private let placeholder : String
    private let contact: Agent
    private let maxWidth = UIScreen.main.bounds.width
    
    init(isShowing: Binding<Bool>, to contact: Agent){
        self.contact = contact
        self.placeholder = "Message..."
        self._isShowing = isShowing
        UITextView.appearance()
            .textContainerInset = UIEdgeInsets(top: 10,
                                               left: 12,
                                               bottom: 0,
                                               right: 40)}
    
    var body: some View {
        VStack (alignment: .center){
            ZStack{
                if contact.id == "support" {
                    Text("Chat with support")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("\(contact.name)\n*your therapist*")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Button {
                        withAnimation {
                            isShowing.toggle()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    Spacer()
                }
            }
            Divider()
            
            ScrollViewReader { proxy in
                ScrollView{
                    ForEach(vm.converesation) { message in
                        MessageCell(message: message)
                            .id(message.id)
                    }
                    .onChange(of: vm.converesation.count) { _ in
                        proxy.scrollTo(vm.converesation.last?.id,
                                       anchor: .bottom)
                    }
                }
            }
            
            
            Divider()
            
            ZStack(alignment: .bottomLeading){
                Color(.tertiarySystemBackground)
                    .cornerRadius(20)
                    .frame(height: 40)
                    .shadow(radius: 3)
                    .opacity(vm.message == nil ? 1 : 0)
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    .opacity(vm.message == nil ? 0.5 : 0)
                TextEditor(text:  Binding($vm.message, replacingNilWith: ""))
                    .transparentScrolling()
                    .background(Color(.tertiarySystemBackground)
                        .opacity(vm.message == nil ? 0 : 1))
                    .frame(minHeight: 40, maxHeight: 120)
                    .fixedSize(horizontal: false, vertical: true)
                    .cornerRadius(20)
                    .shadow(radius: 3)
                
                HStack{
                    Spacer()
                    Button{
                        vm.sendMessage(to: contact.id)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.bottom, 4)
                            .padding(.trailing, 5)
                    }
                }
            }
        }
        .padding()
        .onAppear{
            vm.observeMessages(from: contact.id)
        }
    }
}

public extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}

public extension Binding where Value: Equatable {

    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                } else {
                    source.wrappedValue = newValue
                }
            }
        )
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(isShowing: .constant(true), to: Agent(id: "1234", name: "Saman"))
    }
}
