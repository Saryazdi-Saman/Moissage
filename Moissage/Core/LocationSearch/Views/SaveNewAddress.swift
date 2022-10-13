//
//  SaveNewAddress.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct SaveNewAddress: View {
    @EnvironmentObject var vm : LocationSearchViewModel
    var body: some View {
        VStack(spacing: 10){
            HStack{
                TextField("# Unit number", text: $vm.newAddress.unitNumber)
                    .padding(.leading)
                    .frame(height: 44)
                    .background(Color(.systemGray4))
                TextField("# BUZZER", text: $vm.newAddress.buzzer)
                    .padding(.leading)
                    .frame(height: 44)
                    .background(Color(.systemGray4))
            }
            TextField("Add a label (ex. home or Bobby's appartment)", text: $vm.newAddress.label)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
            TextField("Building name", text: $vm.newAddress.buildingName)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
            TextField("Add instructions", text: $vm.newAddress.instruction)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
            Button {
                withAnimation(.spring()){
                    vm.viewState = .noInput
                }
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
