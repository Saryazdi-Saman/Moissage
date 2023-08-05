//
//  CheckoutView.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-20.
//

import SwiftUI
import StripePaymentSheet

struct CheckoutView: View {
    @EnvironmentObject var manager: SessionManager
    @ObservedObject var vm : LocationSearchViewModel
    @StateObject var backendModel = BackendModel()
    @Binding private var viewState: ViewState
    @Binding private var withDelay: Bool
    @Binding private var delayedTime:Int

    init(viewState: Binding<ViewState>, viewModel: LocationSearchViewModel,
         withDelay: Binding<Bool>,delayedTime: Binding<Int>){
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self._viewState = viewState
        self.vm = viewModel
        self._withDelay = withDelay
        self._delayedTime = delayedTime
    }
    @State private var openSearchBar = false
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .frame(maxHeight: vm.searchVS == .noInput ? 350 : 650)
                .opacity(0.95)
            VStack{
                // MARK: - address bar
                VStack{
                    if vm.searchVS == .noInput {
                        LocationSearchActivationView(viewModel: vm)
                    } else{
                        LocationSearchView(viewModel: vm)
                            .frame(maxHeight: 340)
                    }
                }
                .padding(.vertical,1)
                VStack{
                    Divider().padding(.vertical, 2)
                    HStack{
                        Text("therapist gender")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                        Picker ("gender", selection: $vm.invoice.genderPreference){
                            ForEach(["female","male", "anyone"], id: \.self){Text($0)}
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    //MARK: - total calculator
                    Divider()
                        .padding(.vertical, 2)
                    
                    Spacer()
                    VStack{
                        HStack{
                            Text("Session Total")
                            Spacer()
                            Text("$ \((backendModel.bill["Session Total"] ?? 10000)/100)")
                        }
                        HStack{
                            Text("tax")
                            Spacer()
                            Text(String(format: "$ %.2f", Double((backendModel.bill["tax"] ?? 10000))/100))
                        }
                        HStack{
                            Text("online fees")
                            Spacer()
                            Text(String(format: "$ %.2f", Double((backendModel.bill["online fees"] ?? 10000))/100))
                        }
                        Divider()
                        HStack{
                            Text("total payable")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(String(format: "$ %.2f", Double((backendModel.bill["payable"] ?? 10000))/100))
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.subheadline)
                    .redacted(reason: backendModel.hasUpdated ? []:.placeholder)
                    
                    Divider()
                    // MARK: - request button
                    
                    CheckoutButton(model: backendModel, vm: vm)
                        .padding(.bottom)
                }
                .frame(maxHeight: 250)

            }.padding(.horizontal)
            .cornerRadius(20)
        }
        .onAppear{
            vm.searchVS = .noInput
            vm.invoice = manager.invoice
            backendModel.preparePaymentSheet(forInvoice: vm.invoice)
        }
        .onReceive(backendModel.$invoiceId) { res in
            if let iid = res {
                vm.invoice.invoiceId = iid
            }
        }
        .onReceive(backendModel.$paymentResult) { result in
            switch result {
            case .completed:
                vm.uploadInvoice()
                manager.invoice = vm.invoice
                withAnimation(.spring()) {
                    viewState = .lookingForTherapist
                    withDelay = true
                    delayedTime = 0
                }
            case .failed(_):
                break
            case .canceled:
                break
            case .none:
                break
            }
        }
    }

    
    func taxCalculator()->Double{
        return round(Double(vm.invoice.total) * 14.975)/100
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(viewState: .constant(.checkout),
                     viewModel: LocationSearchViewModel(),
                     withDelay: .constant(true), delayedTime: .constant(0))
            .environmentObject(SessionManager())
    }
}
