//
//  SaveNewAddress.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct SaveNewAddress: View {
    @EnvironmentObject var vm : LocationSearchViewModel
    @State var info : String = ""
    var body: some View {
        VStack(spacing: 10){
            HStack{
                TextField("# Unit number", text: $info)
                    .padding(.leading)
                    .frame(height: 44)
                    .background(Color(.systemGray4))
                TextField("# BUZZER", text: $info)
                    .padding(.leading)
                    .frame(height: 44)
                    .background(Color(.systemGray4))
            }
            TextField("Add a label (ex. home or Bobby's appartment)", text: $info)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
            TextField("Building name", text: $info)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
            TextField("Add instructions", text: $info)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
            Button {
                vm.viewState = .noInput
            } label: {
                Text("SAVE ADDRESS")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 120, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
        }
    }
}

struct SaveNewAddress_Previews: PreviewProvider {
    static var previews: some View {
        SaveNewAddress().environmentObject(LocationSearchViewModel())
    }
}
