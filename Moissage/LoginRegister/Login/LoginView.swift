//
//  LoginView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct LoginView: View {
    @State var email : String = ""
    @State var password : String = ""
    @State var showForgotPassword : Bool = false
    @State var showRegistration : Bool = false
    var body: some View {
        NavigationView{
            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    InputTextFieldView(text: $email,
                                       placeHolder: "Email",
                                       keyboardType: .emailAddress)
                    
                    PasswordField(text: $password,
                                  placeHolder: "Password")
                }
                HStack{
                    Spacer()
                    NavigationLink {
                        ForgotPasswordView(email: "")
                    } label: {
                        Text("Forgot Password")
                            .fontWeight(.semibold)
                    }
                }
                VStack(spacing: 16) {
                    ButtonView(title: "Login") {
                        
                    }
                    NavigationLink(destination: RegistrationView()) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemBlue), lineWidth: 4)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .overlay (
                                Text("Register")
                                    .fontWeight(.bold)
                                    
                            )
                    }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
