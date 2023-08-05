//
//  SaveNewAddress.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct SaveNewAddress: View {
    @ObservedObject var vm: LocationSearchViewModel
    @EnvironmentObject var manager: SessionManager
    init(viewModel vm: LocationSearchViewModel) {
        self.vm = vm
    }
    var body: some View {
        VStack(spacing: 10){
            TextField("Add a label (ex. home or Bobby's appartment)",
                      text: $vm.newAddress.label)
                .padding(.leading)
                .frame(height: 44)
                .background(Color(.systemGray4))
            
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
//                    manager.selectedAddress = vm.selectedLocation
                    vm.saveNewAddress()
//                    vm.searchVS = .noInput
                }
            } label: {
                Text("SAVE ADDRESS")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 120, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
//            Spacer()
            
        }
//        .onAppear{
//            manager.selectedAddress?.address = vm.selectedLocation!.address
//            manager.selectedAddress?.label = vm.selectedLocation!.label
//        }
    }
}

struct SaveNewAddress_Previews: PreviewProvider {
    static var previews: some View {
        SaveNewAddress(viewModel: LocationSearchViewModel())
//            .environmentObject(SessionManager())
    }
}
