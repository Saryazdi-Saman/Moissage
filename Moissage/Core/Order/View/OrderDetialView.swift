//
//  OrderDetialView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct OrderDetailView: View {
    @EnvironmentObject var vm: LocationSearchViewModel
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    @State private var openSearchBar = false
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: vm.searchVS == .noInput ? 500 : .infinity)
                .opacity(0.95)
            VStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(vm.cartManager.cart.mainService.title + " Massage")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .padding(.vertical, 8)
                }
                
                // MARK: - address bar
                VStack{
                    if vm.searchVS == .noInput {
                        LocationSearchActivationView()
                            .padding(.bottom,8)
                    } else{
                        LocationSearchView()
                            .environmentObject(vm)
                    }
                }
                
                // MARK: - Duration Picker
                
                Picker ("Duration", selection: $vm.cartManager.cart.duration){
                    ForEach(MainServiceDuration.allCases, id: \.self){
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                VStack(alignment: .leading){
                    
                    Divider().padding(.vertical, 8)
                    Text("+ add extras to your session:")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                // MARK: - extras
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("head massage")
                            .fontWeight(.semibold)
                        Text("foot massage")
                            .fontWeight(.semibold)
                        Text("therapist gender")
                            .fontWeight(.semibold)
                    }.padding(.trailing, 12)
                        
                        .foregroundColor(.secondary)
                    VStack{
                        Picker ("Head", selection: $vm.cartManager.cart.extraHeadMassage){
                            ForEach(ExtraHeadMassage.allCases, id: \.self){
                                Text($0.rawValue)
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker ("Foot", selection: $vm.cartManager.cart.extraFootMassage){
                            ForEach(ExtraFootMassage.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Picker ("gender", selection: $vm.genderPreference){
                            ForEach(["female","male", "anyone"], id: \.self){Text($0)}
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                //MARK: - total calculator
                Divider()
                    .padding(.vertical, 8)
                HStack{
                    Text("Total:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$ \(String(format: "%.0f", vm.cartManager.cartTotal))")
                        .fontWeight(.bold)
                }
                .padding(.horizontal,4)
                
                Divider()
                    .padding(.vertical, 2)
                
                // MARK: - request button
                Button {
                    if vm.selectedLocation == nil {
                        vm.searchVS = .showSavedAddresses
                    }
                    else {
                        withAnimation {
                            vm.submitOrder()
                            vm.globalVS = .lookingForTherapist
                            print(vm.cartManager.cart.total)
                        }
                    }
                } label: {
                    Text("CONFIRM REQUEST")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }

            }.padding(.horizontal)
                .padding(.vertical, 24)
            .cornerRadius(20)
        }
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView()
            .environmentObject(LocationSearchViewModel())
    }
}
