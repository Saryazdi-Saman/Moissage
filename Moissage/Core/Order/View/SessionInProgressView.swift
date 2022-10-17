//
//  SessionInProgressView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-16.
//

import SwiftUI

struct SessionInProgressView: View {
    @EnvironmentObject var vm : LocationSearchViewModel
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: 400)
                .opacity(0.95)
            VStack(spacing: 10){
                Text(" is on the way")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding()
                
                Divider()
//                LoadingBar()
                //                FlowerLoadingBar()
//                    .padding()
                
            }
        }
    }
}

struct SessionInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SessionInProgressView()
            .environmentObject(LocationSearchViewModel())
    }
}
