//
//  RegistrationView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var appManager : AppManager
    
    var body: some View {
        NavigationView{
                VStack(alignment: .leading, spacing: 10){
                    ScrollView{
                        InputTextFieldView(text: $appManager.newUser.email,
                                           placeHolder: "Email",
                                           keyboardType: .emailAddress)
                        .padding(.bottom,10)
                        PasswordField(text: $appManager.newUser.password,
                                      placeHolder: "Password")
                    
                        .padding(.bottom,10)
                        InputTextFieldView(text: $appManager.newUser.firstName,
                                           placeHolder: "First Name",
                                           keyboardType: .alphabet)
                        .padding(.bottom,10)
                        InputTextFieldView(text: $appManager.newUser.lastName,
                                           placeHolder: "Last Name",
                                           keyboardType: .alphabet)
                        .padding(.bottom,10)
                        InputTextFieldView(text: $appManager.newUser.phoneNumber,
                                           placeHolder: "Phone Number: (xxx) xxx - xxxx",
                                           keyboardType: .numberPad)
                        .padding(.bottom,10)
                        ButtonView(title: "Sign up") {
                            guard !appManager.newUser.email.isEmpty,
                                  !appManager.newUser.password.isEmpty,
                                  !appManager.newUser.firstName.isEmpty,
                                  !appManager.newUser.lastName.isEmpty,
                                  !appManager.newUser.phoneNumber.isEmpty else{
                                return
                            }
                            appManager.creatAccount()
                        }
                    }
                    
                    
                
                
                }
                .padding(15)
//                .alert(isPresented: $viewModel.hasError) {
//                    if case .failed(let error) = viewModel.state{
//                        return Alert(title: Text("Error"),
//                                     message: Text(error.localizedDescription))
//                    } else {
//                        return Alert(title: Text("Error"),
//                                     message: Text("Something went wrong"))
//                    }
//                }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AppManager())
    }
}
