//
//  BackendModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-25.
//

import StripePaymentSheet
import SwiftUI

class BackendModel: ObservableObject {
    
    let backendCheckoutUrl = URL(string: "https://paymentsheet-qmtthe7q5a-uc.a.run.app")! // Your backend endpoint
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var bill: [String: Int] = [
        "Session Total" : 20000,
        "tax" : 3000,
        "online fees" : 690,
        "payable" : 23690,
    ]
    @Published var hasUpdated = false
    @Published var invoiceId : Int?
    
    func preparePaymentSheet(forInvoice invoice: Invoice?) {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        guard let invoice = invoice else { return }
        var request = URLRequest(url: backendCheckoutUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(invoice)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//                  let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  var meta = json["bill"] as? [String: Any],
                  let iid = meta["iid"] as? Int,
                  let self = self else {
                print("DEBUG: BackendModel: error in http request")
                // Handle error
                return
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.returnURL = "mytestapp://stripe-redirect"
            configuration.merchantDisplayName = "Example, Inc."
            configuration.customer = .init(id: invoice.stripeId, ephemeralKeySecret: customerEphemeralKeySecret)
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = true
            meta.removeValue(forKey: "uid")
            meta.removeValue(forKey: "iid")
            DispatchQueue.main.async {
                guard let bill = meta as? [String: Int] else {
                    print("DEBUG: BackendModel: Could not convert recieved data to bill")
                    return
                }
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
                self.bill = bill
                self.invoiceId = iid
                self.hasUpdated = true
            }
        })
        task.resume()
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
    
}
