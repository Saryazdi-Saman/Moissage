//
//  LoadingView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-16.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: 400)
                .opacity(0.95)
            VStack(spacing: 10){
                Text("Connecting you to a therapist")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding()
                
                Divider()
                    .padding(.bottom, 50)
                
                    LoadingBar()
                        .padding()
                
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
