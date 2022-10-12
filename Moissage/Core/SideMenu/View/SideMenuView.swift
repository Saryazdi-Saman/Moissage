//
//  SideMenuView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        
        ZStack (alignment: .topLeading){
            LinearGradient(gradient: Gradient(colors: [Color.blue , Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(alignment: .leading){
                
                //Header ( Name / LastName / email )
                SideMenuHeader()
                    .foregroundColor(.white)
                    .padding()
                
                //Cells ( Profile, Transaactions, ReferalCode, Become a member, logout)
                ForEach (0..<5){ _ in
                    SideMenuCells()
                }
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
