//
//  CheckoutButton.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-25.
//

import SwiftUI
import StripePaymentSheet

struct CheckoutButton: View {
    @ObservedObject var model : BackendModel
    @ObservedObject var vm: LocationSearchViewModel
    
    var body: some View {
        VStack {
            if let result = model.paymentResult {
                switch result {
                case .completed:
                    Text("Payment complete")
                case .failed(let error):
                    Text("Payment failed: \(error.localizedDescription)")
                        .foregroundColor(Color(.systemRed))
                case .canceled:
                    Text("Payment canceled.")
                        .foregroundColor(Color(.systemRed))
                }
            }
            if let paymentSheet = model.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: model.onPaymentCompletion
                ) {
                    Text("CONFIRM REQUEST")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }.disabled(vm.invoice.address == nil)
            } else {
                Text("Loading…")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .opacity(0.5)
                    .foregroundColor(.white)
            }
            
        }
    }
}

struct CheckoutButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutButton(model: BackendModel(), vm: LocationSearchViewModel())
    }
}
