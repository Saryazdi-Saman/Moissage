//
//  DismissButton.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack{
                Circle()
                    .fill(Color(.systemBackground))
                    .shadow(color:.secondary ,radius: 4)
                    .frame(width: 55, height: 55)
                Image(systemName: "arrow.left")
                    .font(.title3)
                    .foregroundColor(.primary)
                    
            }
            .padding()
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
