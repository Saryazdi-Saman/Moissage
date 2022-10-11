//
//  PasswordField.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct PasswordField: View {
    @Binding var text : String 
    let placeHolder : String
    
    var body: some View {
        SecureField(placeHolder, text: $text)
            .frame(width: UIScreen.main.bounds.size.width - 40,
                   height: 50)
            .padding(.leading, 30)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(text: .constant(""), placeHolder: "Password")
    }
}
