//
//  CartViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-12.
//

import Foundation

final class CartViewModel : ObservableObject{
    
    @Published var cartTotal : Double
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
                    preferredGender: UserDefaults.standard.string(forKey: "gender") ?? "anyone")
        cartTotal = Double(MainServiceDuration.oneHour.price)
        
    }
    
    private func calculateTotal(){
        let total = Double(cart.duration.price
                           + cart.extraHeadMassage.price
                           + cart.extraFootMassage.price)
        self.cartTotal = total
    }
}
