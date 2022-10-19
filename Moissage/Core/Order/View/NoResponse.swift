//
//  NoResponse.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-18.
//

import SwiftUI

struct NoResponse: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: 400)
                .opacity(0.95)
            VStack(alignment: .leading, spacing: 4){
                Text("Stay on the waiting list").font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                Divider()
                    .padding()
                
                Text("Looks Like everyone is busy")
                Text("But we can Keep you on the waiting list")
                
            }
            .padding()
        }
    }
}

struct NoResponse_Previews: PreviewProvider {
    static var previews: some View {
        NoResponse()
    }
}
