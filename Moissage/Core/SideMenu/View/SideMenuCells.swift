//
//  SideMenuCells.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct SideMenuCells: View {
    var body: some View {
        HStack(spacing: 16){
            Image(systemName: "person")
                .resizable()
                .frame(width: 24, height: 24)
                
            Text("Profile")
                .font(.system(size: 15, weight: .semibold))
            Spacer()
        }.foregroundColor(.white)
            .padding()
    }
}

struct SideMenuCells_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuCells()
    }
}
