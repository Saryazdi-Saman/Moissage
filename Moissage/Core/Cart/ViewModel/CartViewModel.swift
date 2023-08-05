//
//  CartViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-26.
//

import SwiftUI
import Combine

class CartViewModel: ObservableObject{
    let service = CartService()
    @Published var state: RegistrationState = .na
    @Published var hasError: Bool = false
    var pricing: [String:Int] = ["-":0]
//    @Published var invoice: Invoice?
    
    private var subscriptions = Set<AnyCancellable>()
    var mainService : MassageType
    var duration : MainService {
        didSet {
            calculateTotal()
        }
    }
    var extraHeadMassage : Extras {
        didSet {
            calculateTotal()
        }
    }
    var extraFootMassage : Extras  {
        didSet {
            calculateTotal()
        }
    }
    @Published var total: Int
    
    init(){
        self.mainService = .relaxing
        self.duration = .oneHour
        self.extraHeadMassage = .none
        self.extraFootMassage = .none
        self.total = self.pricing["60 min"] ?? 0
        self.setupErrorSubscription()
    }
    
    
    var items : [Product] {
        var products = [Product]()
        products.append(Product(name: mainService.title,
                                duration: duration.rawValue))
        if extraHeadMassage != .none {
            products.append(Product(name: String("Head massage"),
                                    duration: extraHeadMassage.rawValue))
        }
        if extraFootMassage != .none {
            products.append(Product(name: String("Foot massage"),
                                    duration: extraFootMassage.rawValue))
        }
        return products
    }
    
    func calculateTotal(){
//        self.total = duration.price + extraHeadMassage.price + extraFootMassage.price
        self.total = (pricing[duration.rawValue] ?? 10) + (pricing[extraHeadMassage.rawValue] ?? 0) + (pricing[extraFootMassage.rawValue] ?? 0)
    }
    
    func totalWithTax()->Int{
        return Int(round((Double(total) * 1.14975)*100))
    }
    
//    func submitCart(completion: @escaping (_ res: Bool) -> Void ){
//        self.invoice!.invoiceId = generateInvoiceNumber()
//        self.invoice!.total = total
//        self.invoice!.payable = totalWithTax()
//        service.registerOrder(withCart: items, invoice: invoice!)
//            .sink {[weak self] res in
//                switch res {
//                case .failure(let error):
//                    self?.state = .failed(error: error)
//                    completion(false)
//                default:
//                    break
//                }
//            } receiveValue: { [weak self] in
//                self?.state = .successfullyRegistered
//                completion(true)
//            }.store(in: &subscriptions)
//    }
    
    func updateInvoice(_ invoice: Invoice) -> Invoice{
        var invoice = invoice
        invoice.total = total
        invoice.payable = totalWithTax()
        invoice.items = items
        return invoice
    }
    
    private func generateInvoiceNumber()->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
        
        return dateFormatter.string(from: date)
    }
}

private extension CartViewModel{
    func setupErrorSubscription(){
        $state
            .map { state -> Bool in
                switch state {
                case .successfullyRegistered,
                        .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
