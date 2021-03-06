//
//  TwoForOneOffer.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

public class TwoForOneOffer: Offer {
    private let codes: [String]
    public let name: String

    public init(name: String = "Two For One", discountedProduct codes: [String]) {
        self.name = name
        self.codes = codes
    }

    public func discount(over products: [StoreProduct]) -> Float {
        codes
            .map { (products, $0) }
            .map(applyDiscount)
            .reduce(0, +)
    }

    private func applyDiscount(over products: [StoreProduct], using code: String) -> Float {
        let products = products.filter { $0.code == code }

        guard products.count >= 2 else {
            return 0
        }

        let repeatedCount = Int(products.count / 2)

        return products[0].price * Float(repeatedCount)
    }
}
