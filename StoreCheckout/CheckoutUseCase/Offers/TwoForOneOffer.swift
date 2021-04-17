//
//  TwoForOneOffer.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

class TwoForOneOffer: Offer {
    func discount(over products: [StoreProduct]) -> Float {
        return applyDiscountBasedOnRepeatedProducts(
            products: amountByProduct(products: products)
        )
    }

    private func applyDiscountBasedOnRepeatedProducts(products: [StoreProduct: Int]) -> Float {
        products.map { (product, count) -> Float in
            let repeatedCount = Int(count / 2)
            return product.price * Float(repeatedCount)
        }.reduce(0, +)
    }

    private func amountByProduct(products: [StoreProduct]) -> [StoreProduct: Int] {
        var amountByProduct: [StoreProduct: Int] = [:]
        products.forEach { product in
            if amountByProduct[product] == nil {
                amountByProduct[product] = 1
            } else {
                amountByProduct[product] = amountByProduct[product]?.advanced(by: 1)
            }
        }
        return amountByProduct
    }
}
