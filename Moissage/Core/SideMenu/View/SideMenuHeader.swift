//
//  SideMenuHeader.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct SideMenuHeader: View {
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width:60, height: 60)
            Text("Saman Saryazdi")
                .font(.system(size: 20, weight: .semibold))
            Text(verbatim: "saman.s90@gmail.com")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct SideMenuHeader_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeader()
    }
}
