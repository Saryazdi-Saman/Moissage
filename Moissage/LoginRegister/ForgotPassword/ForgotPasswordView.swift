//
//  ForgotPasswordView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ForgotPasswordViewModelImp(service: ForgotPasswordServiceImp())

    var body: some View {
        NavigationView{
            VStack (spacing: 16){
                InputTextFieldView(text: $viewModel.email, placeHolder: "Email", keyboardType: .emailAddress)
                ButtonView(title: "Send Reset Password Link") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(15)
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
