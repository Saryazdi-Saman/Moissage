//
//  CartView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var manager: SessionManager
    @ObservedObject var cartVM: CartViewModel
    @Binding var viewState: ViewState
    @Binding var withDelay:Bool
    @Binding var delayedTime:Int
    
    init(_ cartVM: CartViewModel,
         viewState: Binding<ViewState>,
         withDelay: Binding<Bool>,
         delayedTime: Binding<Int>){
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.cartVM = cartVM
        self._viewState = viewState
        self._withDelay = withDelay
        self._delayedTime = delayedTime
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 400 )
                .opacity(0.95)
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 10){
                    Text(cartVM.mainService.title + " Massage")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .padding(.bottom, 8)
                }
                
                // MARK: - Duration Picker
                Text("Service duration:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Picker ("Duration", selection: $cartVM.duration){
                    ForEach(MainService.allCases, id: \.self){
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
                
                // MARK: - extras
                Text("+ add extras to your session:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                HStack{
                    VStack(alignment: .leading, spacing: 20){
                        Text("head massage")
                            .fontWeight(.semibold)
                        Text("foot massage")
                            .fontWeight(.semibold)
                    }.padding(.trailing, 12)
                        
                        .foregroundColor(.secondary)
                    VStack{
                        Picker ("Head", selection: $cartVM.extraHeadMassage){
                            ForEach(Extras.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker ("Foot", selection: $cartVM.extraFootMassage){
                            ForEach(Extras.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                Divider()
                    .padding(.vertical, 8)
                
                //MARK: - total calculator
                HStack{
                    Text("Total:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$ " + String(cartVM.total))
                        .fontWeight(.bold)
                }
                .padding(.horizontal,4)
                
                // MARK: - request button
                if cartVM.hasError{
                    Text("Failed connecting to server")
                        .foregroundColor(Color(.systemRed))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.leading, 75)
                }
                Button {
                    manager.invoice = cartVM.updateInvoice(manager.invoice)
                    withAnimation(.spring()) {
                        viewState = .checkout
                        withDelay = true
                        delayedTime = 0
                    }
                } label: {
                    Text("CONFIRM REQUEST")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }

            }
            .padding(.horizontal)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(CartViewModel(),
                 viewState: .constant(.orderDetails),
                 withDelay: .constant(true), delayedTime: .constant(0))
    }
}
