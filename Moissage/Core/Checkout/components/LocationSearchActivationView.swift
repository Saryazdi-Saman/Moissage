//
//  LocationSearchActivationView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchActivationView: View {
    @ObservedObject var vm: LocationSearchViewModel
    init (viewModel vm: LocationSearchViewModel){
        self.vm = vm
    }
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(Color(.systemRed))
                .font(.largeTitle)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray4))
                .frame(height: 36)
                .overlay (
                    HStack{
                        Text(vm.invoice.address?.label?.capitalized ??
                             vm.invoice.address?.address.capitalized ??
                             "Select address")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        Spacer()
                    }.padding(.leading)
                )
        }
        .onTapGesture {
            withAnimation(.spring()){
                vm.searchVS = .showSavedAddresses
            }
        }
        
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView(viewModel: LocationSearchViewModel())
    }
}
