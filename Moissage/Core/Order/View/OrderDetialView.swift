//
//  OrderDetialView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var cartVM : CartViewModel
    @EnvironmentObject var locationVM: LocationSearchViewModel
    
    init(viewModel : CartViewModel){
        self.cartVM = viewModel
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    @State private var openSearchBar = false
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: locationVM.viewState == .noInput ? 500 : .infinity)
                .opacity(0.95)
            VStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(cartVM.cart.mainService.title + " Massage")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .padding(.vertical, 8)
                }
                
                // MARK: - address bar
                VStack{
                    if locationVM.viewState == .noInput {
                        LocationSearchActivationView()
                            .padding(.bottom,8)
                    } else{
                        LocationSearchView()
                            .environmentObject(locationVM)
                    }
                }
                
                // MARK: - Duration Picker
                
                Picker ("Duration", selection: $cartVM.cart.duration){
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
                        Picker ("Head", selection: $cartVM.cart.extraHeadMassage){
                            ForEach(ExtraHeadMassage.allCases, id: \.self){
                                Text($0.rawValue)
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker ("Foot", selection: $cartVM.cart.extraFootMassage){
                            ForEach(ExtraFootMassage.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Picker ("gender", selection: $locationVM.genderPreference){
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
                    Text("$ \(String(format: "%.0f", cartVM.cartTotal))")
                        .fontWeight(.bold)
                }
                .padding(.horizontal,4)
                
                Divider()
                    .padding(.vertical, 2)
                
                // MARK: - request button
                Button {
                    if locationVM.selectedLocation == nil {
                        locationVM.viewState = .showSavedAddresses
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
        OrderDetailView(viewModel: CartViewModel())
            .environmentObject(LocationSearchViewModel())
    }
}
