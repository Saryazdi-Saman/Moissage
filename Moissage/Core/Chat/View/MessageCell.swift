//
//  MessageCell.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-04.
//

import SwiftUI
struct MessageCell: View {
    let message : Message
    private var isFromUser : Bool {
        return message.isFromCurrentUser
    }
    var body: some View {
        HStack{
            if isFromUser {
                Spacer()
                Text(message.body)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(12)
                    .background(Color(.systemBlue))
                    .foregroundColor(Color(.white))
                    .clipShape(ChatBubble(isFromCurrentUser: isFromUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                Text(message.body)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(12)
                    .background(Color(.systemGray4))
                    .foregroundColor(Color.primary)
                    .clipShape(ChatBubble(isFromCurrentUser: isFromUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .leading)
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
}

struct MessageCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(message: Message(fromId: "", toId: "1", body: "Heye", uid: "1"))
    }
}
