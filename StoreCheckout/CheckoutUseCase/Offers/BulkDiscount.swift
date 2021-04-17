//
//  BulkDiscount.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

class BulkDiscount: Offer {
    struct Config {
        let code: String
        let newPrice: Float
        let minimumAmount: Int
    }

    private let config: [Config]

    init(config: [Config]) {
        self.config = config
    }

    func discount(over products: [StoreProduct]) -> Float {
        config
            .map { (products, $0) }
            .map(applyDiscount)
            .reduce(0, +)
    }

    private func applyDiscount(over products: [StoreProduct], using config: Config) -> Float {
        let discountedItem = products.filter { $0.code == config.code }

        guard discountedItem.count >= config.minimumAmount else {
            return 0
        }

        let originalPrice = discountedItem[0].price
        let discountPerItem = originalPrice - config.newPrice

        return Float(discountedItem.count) * discountPerItem
    }
}
