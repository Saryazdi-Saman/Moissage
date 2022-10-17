//
//  sideMenu.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-15.
//

import SwiftUI

struct sideMenu: View {
    var body: some View {
        ZStack (alignment: .topLeading){
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: .infinity)
                .frame(width: 220)
                .opacity(0.95)
                .shadow(color: .secondary, radius: 3)
            VStack(alignment: .leading){
                SideMenuHeader()
                    .padding(.horizontal)
                
                HStack(spacing: 16){
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 24, height: 24)
                        
                    Text("Profile")
                        .font(.system(size: 15, weight: .semibold))
                }.foregroundColor(.primary)
                    .padding()
                
                logout()
                    .onTapGesture {
                        SessionManager.shared.logout()
                    }
            }
            .padding()
        }
    }
}

struct sideMenu_Previews: PreviewProvider {
    static var previews: some View {
        sideMenu()
    }
}
