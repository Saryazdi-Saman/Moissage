//
//  LoginView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModelImpl(
        service: LoginServiceImpl()
    )
    
    @State var email : String = ""
    @State var password : String = ""
    
    var body: some View {
        NavigationView{
            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    InputTextFieldView(text: $viewModel.credentials.email,
                                       placeHolder: "Email",
                                       keyboardType: .emailAddress)
                    
                    PasswordField(text: $viewModel.credentials.password,
                                  placeHolder: "Password")
                }
                HStack{
                    Spacer()
                    NavigationLink {
                        ForgotPasswordView()
                    } label: {
                        Text("Forgot Password")
                            .fontWeight(.semibold)
                    }
                }
                
                VStack(spacing: 16) {
                    ButtonView(title: "Login") {
//                        guard !email.isEmpty, !password.isEmpty else{
//                            return
//                        }
                        viewModel.login()
                    }
                    
                    NavigationLink(destination: RegistrationView()) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemBlue), lineWidth: 4)
                            .frame(width: UIScreen.main.bounds.size.width - 40,
                                   height: 50)
                            .overlay (
                                Text("Creat Account")
                                    .fontWeight(.bold)
                                    
                            )
                    }
                }
            }
            .padding(.horizontal, 15)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
