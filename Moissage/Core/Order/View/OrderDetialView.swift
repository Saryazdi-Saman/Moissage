//
//  OrderDetialView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI

struct OrderDetailView: View {
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
//    @EnvironmentObject var viewModel: LocationSearchViewModel
//    @EnvironmentObject var cartManager : CartManager
    @State var name = ""
    @State var addressBar = ""
    @State var serviceDuration = "60 min"
    @State var extraHead = "-"
    @State var extraFoot = "-"
    @State var gender = "female"
    
    @State private var adressText: String = ""
//    @State var locationSelectionState = LocationSelectionState.noInput
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: 500)
                .opacity(0.95)
            VStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(name + " Massage")
                    //                    .font(.subheadline)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .padding(.vertical, 8)
                }
                
                // MARK: - address bar
                VStack{
                    HStack{
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(Color(.systemRed))
                            .font(.largeTitle)
                        TextField("choose address", text: $addressBar)
                            .frame(height: 38)
                            .padding(5)
                            .background(Color(.systemGray4))
                            .onTapGesture {
    //                            withAnimation {
    //                                locationSelectionState = .searchAdress
    //                            }
                            }
                    }
                    .padding(.bottom,8)
    //                if locationSelectionState == .searchAdress{
    //                    ScrollView{
    //                        VStack(alignment: .leading) {
    //                            if viewModel.results.count == 0 {
    //                                ForEach( savedAdresses, id: \.self){ result in
    //                                    LocationSearchResultCell(title: result.name,
    //                                                             subtitle: result.adress)
    //                                    .onTapGesture {
    //                                        viewModel.selectLocation(result.adress)
    //                                        withAnimation(.spring()) {
    //                                            locationSelectionState = .noInput
    //                                        }
    //
    //                                    }
    //                                }
    //                            } else {
    //                                ForEach(viewModel.results, id: \.self){ result in
    //                                    LocationSearchResultCell(title: result.title,
    //                                                             subtitle: result.subtitle)
    //                                    .onTapGesture {
    //                                        viewModel.selectLocation(result.title)
    //                                        withAnimation(.spring()) {
    //                                            locationSelectionState = .saveNewAdress
    //                                        }
    //
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //                if locationSelectionState == .saveNewAdress{
    //                    ScrollView{
    //                        SaveNewAddress()
    //                    }
    //                }
                }
                
                // MARK: - Duration Picker
                
                Picker ("Duration", selection: $serviceDuration){
                    ForEach(["60 min","90 min", "120 min"], id: \.self){Text($0)}
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
                        Picker ("Head", selection: $extraHead){
                            ForEach(["-","15 min", "30 min"], id: \.self){Text($0)}
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker ("Foot", selection: $extraFoot){
                            ForEach(["-","15 min", "30 min"], id: \.self){Text($0)}
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Picker ("Foot", selection: $gender){
                            ForEach(["female","male", "anyone"], id: \.self){Text($0)}
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                //MARK: - total calculator
                Divider()
                    .padding(.vertical, 8)
                HStack{
                    Text("total:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$")
                        .fontWeight(.bold)
                }
                
                Divider()
                    .padding(.vertical, 2)
                
                // MARK: - request button
                Button {
                    
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
    //            .background(.white)
            .cornerRadius(20)
        }
    }
}


struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView()
    }
}
