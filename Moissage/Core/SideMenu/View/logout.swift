//
//  logout.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-15.
//

import SwiftUI

struct logout: View {
    var body: some View {
        HStack(spacing: 16){
            Image(systemName: "lock")
                .resizable()
                .frame(width: 20, height: 25)
                
            Text("Log out")
                .font(.system(size: 15, weight: .semibold))
        }.foregroundColor(.primary)
            .padding()
    }
}

struct logout_Previews: PreviewProvider {
    static var previews: some View {
        logout()
    }
}
