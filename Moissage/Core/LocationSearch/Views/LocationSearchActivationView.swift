//
//  LocationSearchActivationView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import SwiftUI

struct LocationSearchActivationView: View {
    @EnvironmentObject var vm : LocationSearchViewModel
    
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(Color(.systemRed))
                .font(.largeTitle)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray4))
                .frame(height: 44)
                .overlay (
                    HStack{
                        Text(vm.selectedLocation?.label ??
                             vm.selectedLocation?.address ??
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
                vm.viewState = .showSavedAddresses
            }
        }
        
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView().environmentObject(LocationSearchViewModel())
    }
}
