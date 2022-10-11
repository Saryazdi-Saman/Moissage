//
//  RegistrationView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct RegistrationView: View {
//    @Environment(\.presentationMode) var presentationMode
    
    @State var email : String = ""
    @State var password : String = ""
    @State var firstName : String = ""
    @State var lastName : String = ""
    @State var phoneNumber : String = ""
    var body: some View {
        NavigationView{
                VStack(alignment: .leading, spacing: 16){
                    Spacer()
                    Text("CREAT ACCOUNT")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    VStack(spacing: 16){
                        InputTextFieldView(text: $email,
                                           placeHolder: "Email",
                                           keyboardType: .emailAddress)
                        PasswordField(text: $password, placeHolder: "Password")
                    }
                    Divider()
                    VStack{
                        InputTextFieldView(text: $firstName,
                                           placeHolder: "First Name",
                                           keyboardType: .default)
                        .padding(.bottom,5)
                        InputTextFieldView(text: $lastName,
                                           placeHolder: "Last Name",
                                           keyboardType: .default)
                        .padding(.bottom,5)
                        InputTextFieldView(text: $phoneNumber,
                                           placeHolder: "Phone Number: (xxx) xxx - xxxx",
                                           keyboardType: .numberPad)
                        .padding(.bottom,5)
                    }
                    
                    ButtonView(title: "Sign up") {
//                        viewModel.create()
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
        RegistrationView()
    }
}
