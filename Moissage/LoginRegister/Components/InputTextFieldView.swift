//
//  InputTextFieldView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct InputTextFieldView: View {
    @Binding var text : String
    let placeHolder : String
    let keyboardType : UIKeyboardType
    
    var body: some View {
        if #available(iOS 15.0, *) {
            TextField(placeHolder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .frame(width: UIScreen.main.bounds.size.width - 40,
                       height: 50)
                .padding(.leading, 30)
                .keyboardType(keyboardType)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 4)
        } else {
            TextField(placeHolder, text: $text)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .frame(width: UIScreen.main.bounds.size.width - 40,
                       height: 50)
                .padding(.leading, 30)
                .keyboardType(keyboardType)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 4)
        }
    }
}

struct InputTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputTextFieldView(text: .constant(""), placeHolder: "Username", keyboardType: .default)
    }
}
