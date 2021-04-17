//
//  Checkout.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

public class Checkout {
    let products: [StoreProduct]
    let offers: [Offer]

    public init(products: [StoreProduct], offers: [Offer]) {
        self.products = products
        self.offers = offers
    }

    public var costBeforeReductions: Float {
        products.map(\.price).reduce(0, +)
    }

    public var costAfterReductions: Float {
        let reductions = offers.reduce(0, { reductions, offer in
            return reductions + offer.discount(over: products)
        })
        return costBeforeReductions - reductions
    }

    public var applicableOffers: [String] {
        offers.filter { (offer) -> Bool in
            offer.discount(over: products) > 0
        }.map(\.name)
    }
}
