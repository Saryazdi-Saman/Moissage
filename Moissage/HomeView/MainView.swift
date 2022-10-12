//
//  MainView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-10.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appManager : SessionManager
    
    var body: some View {
        Button {
            appManager.logout()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 50)
                .overlay (
                    Text("Logout")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                )
        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
