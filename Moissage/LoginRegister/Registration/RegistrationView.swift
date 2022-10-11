//
//  RegistrationView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModelImpl(
            service: RegistrationServiceImpl()
        )
    
    var body: some View {
        NavigationView{
                VStack(spacing: 10){
                    ScrollView{
                        InputTextFieldView(text: $viewModel.newUser.email,
                                           placeHolder: "Email",
                                           keyboardType: .emailAddress)
                        .padding(.bottom,10)
                        PasswordField(text: $viewModel.newUser.password,
                                      placeHolder: "Password")
                    
                        .padding(.bottom,10)
                        InputTextFieldView(text: $viewModel.newUser.firstName,
                                           placeHolder: "First Name",
                                           keyboardType: .alphabet)
                        .padding(.bottom,10)
                        InputTextFieldView(text: $viewModel.newUser.lastName,
                                           placeHolder: "Last Name",
                                           keyboardType: .alphabet)
                        .padding(.bottom,10)
                        InputTextFieldView(text: $viewModel.newUser.phoneNumber,
                                           placeHolder: "Phone Number: (xxx) xxx - xxxx",
                                           keyboardType: .numberPad)
                        .padding(.bottom,10)
                        ButtonView(title: "Sign up") {
//                            guard !viewModel.newUser.email.isEmpty,
//                                  !viewModel.newUser.password.isEmpty,
//                                  !viewModel.newUser.firstName.isEmpty,
//                                  !viewModel.newUser.lastName.isEmpty,
//                                  !viewModel.newUser.phoneNumber.isEmpty else{
//                                return
//                            }
                            viewModel.create()
                        }
                    }
                }
                .padding(15)
                .alert(isPresented: $viewModel.hasError,
                        content: {
                         
                         if case .failed(let error) = viewModel.state {
                             return Alert(
                                 title: Text("Error"),
                                 message: Text(error.localizedDescription))
                         } else {
                             return Alert(
                                 title: Text("Error"),
                                 message: Text("Something went wrong"))
                         }
                 })
            
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
