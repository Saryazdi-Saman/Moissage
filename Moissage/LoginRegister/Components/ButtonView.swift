//
//  ButtonView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct ButtonView: View {
    typealias ActionHandler = ()->Void
    
    let title : String
    let background: Color
    let forground : Color
    let border : Color
    let handler : ActionHandler
    
    let cornerRadius : CGFloat = 20
    
    internal init(title: String,
                  background: Color = Color(.systemBlue),
                  forground: Color = .white,
                  border: Color = .clear,
                  handler: @escaping ButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.forground = forground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity,
                       maxHeight: 50)
                .background(background)
                .cornerRadius(12)
                .foregroundColor(forground)
        }
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(border, lineWidth: 2)
        )
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: ""){}
    }
}
