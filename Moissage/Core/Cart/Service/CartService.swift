//
//  CartService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-26.
//

import Foundation
import FirebaseDatabase
import Combine

struct CartService {
    func registerOrder(withCart cart: [Product], invoice: Invoice) -> AnyPublisher<Void, Error> {
        Deferred{
            Future{ promise in
//                guard var invoice = SessionManager.shared.invoice else { return }
//                let invoiceNumber = generateInvoiceNumber()
//                invoice.invoiceId = invoiceNumber
//                invoice.total = total
//                invoice.payable = payable
//                invoice.hasUpdated = true
//                SessionManager.shared.invoice = invoice
                
//                print("DEBUG: CartService - Total is: \(SessionManager.shared.invoice?.total)")
                
                var record = ["invoiceNumber" : invoice.invoiceId,
                              "payable": String(invoice.payable)]
                for index in 0..<cart.count {
                    record[String(index+1)] = cart[index].name
                }
                Database.database().reference()
                    .child("user/client/\(invoice.uid)/invoice/inProgress/")
                    .setValue(record) { error, _ in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
//    private func generateInvoiceNumber()->String{
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyMMddHHmmss"
//        
//        return dateFormatter.string(from: date)
//    }
}
