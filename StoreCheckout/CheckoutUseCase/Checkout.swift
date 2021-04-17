//
//  Checkout.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

class Checkout {
    let products: [StoreProduct]
    let offers: [Offer]

    init(products: [StoreProduct], offers: [Offer]) {
        self.products = products
        self.offers = offers
    }

    var costBeforeReductions: Float {
        products.map(\.price).reduce(0, +)
    }

    var costAfterReductions: Float {
        let reductions = offers.reduce(0, { reductions, offer in
            return reductions + offer.discount(over: products)
        })
        return costBeforeReductions - reductions
    }

    var applicableOffers: [String] {
        offers.filter { (offer) -> Bool in
            offer.discount(over: products) > 0
        }.map(\.name)
    }
}
