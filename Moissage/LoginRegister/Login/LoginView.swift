//
//  LoginView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appManager : AppManager
    
    @State var email : String = ""
    @State var password : String = ""
    
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
                        ForgotPasswordView()
                    } label: {
                        Text("Forgot Password")
                            .fontWeight(.semibold)
                    }
                }
                
                VStack(spacing: 16) {
                    ButtonView(title: "Login") {
                        guard !email.isEmpty, !password.isEmpty else{
                            return
                        }
                        appManager.signIn(email: email,
                                          password: password)
                    }
                    
                    NavigationLink(destination: RegistrationView().environmentObject(appManager)) {
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
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
