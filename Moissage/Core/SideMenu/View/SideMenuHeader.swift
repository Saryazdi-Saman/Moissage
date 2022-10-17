//
//  SideMenuHeader.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct SideMenuHeader: View {
    @State var name: String =
    UserDefaults.standard.string(forKey: "firstName")?.capitalized ?? ""
    @State var lastName: String =
    UserDefaults.standard.string(forKey: "lastName")?.capitalized ?? ""
    @State var email: String =
    UserDefaults.standard.string(forKey: "email")?.lowercased() ?? ""
    @State var phone: String =
    UserDefaults.standard.string(forKey: "phoneNumber")?.lowercased() ?? ""
    
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width:60, height: 60)
            Text(name + " " + lastName)
                .font(.system(size: 20, weight: .semibold))
            Text(verbatim: email)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(phone)
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
