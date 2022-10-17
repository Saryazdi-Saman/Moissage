//
//  CartManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-16.
//

import Foundation

final class CartManager: ObservableObject{
    
    @Published var cartTotal : Double
    var total : Int {
        return cart.duration.price + cart.extraFootMassage.price + cart.extraHeadMassage.price
    }
    var cart : Cart {
        didSet{
            calculateTotal()
        }
    }
    
    init(){
        cart = Cart(mainService: .relaxing,
                    duration: .oneHour,
                    extraHeadMassage: .none,
                    extraFootMassage: .none,
                    preferredGender: UserDefaults.standard.string(forKey: "preferredGender") ?? "anyone")
        cartTotal = Double(MainServiceDuration.oneHour.price)
    }
    
    private func calculateTotal(){
        let total = Double(cart.duration.price
                           + cart.extraHeadMassage.price
                           + cart.extraFootMassage.price)
        self.cartTotal = total
    }
}
