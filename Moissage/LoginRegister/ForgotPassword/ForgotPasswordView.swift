//
//  ForgotPasswordView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email : String
    var body: some View {
        NavigationView{
            VStack (alignment: .leading, spacing: 16){
//                DismissButton()
                Spacer()
                InputTextFieldView(text: $email, placeHolder: "Email", keyboardType: .emailAddress)
                ButtonView(title: "Send Reset Password Link") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            .padding(15)
//            .toolbar {
//                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
//                    
//                }
//            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(email: "")
    }
}
