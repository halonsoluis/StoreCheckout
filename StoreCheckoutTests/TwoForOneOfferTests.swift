//
//  TwoForOneOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class TwoForOneOffer: Offer {
    func discount(over products: [StoreProduct]) -> Float {

        let amountOfProducts = amountByProduct(products: products)

        return amountOfProducts.map { (product, count) in
            let repeatedCount = Int(count / 2)
            return product.price * Float(repeatedCount)
        }.reduce(0, +)
    }

    func amountByProduct(products: [StoreProduct]) -> [StoreProduct: Int] {
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

class TwoForOneOfferTests: XCTestCase {

    let voucher = StoreProduct(code: "VOUCHER", name: "Voucher", price: 5)
    let tShirt = StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20)
    let mug = StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)
    let mug2 = StoreProduct(code: "MUG-2", name: "Coffee Mug", price: 7.5)

    func test_offer_returnsNoDiscountOnEmptyBasket() throws {
        let offer = TwoForOneOffer()

        XCTAssertEqual(offer.discount(over: []), 0)
    }

    func test_offer_returnsZeroOnDifferentProducts() throws {
        let offer = TwoForOneOffer()
        let products = [voucher, tShirt, mug]
        XCTAssertEqual(offer.discount(over:products), 0)
    }

    func test_offer_returnsAmountOfRepeatedProducts() throws {
        let offer = TwoForOneOffer()

        let products = [voucher, voucher, mug, mug2, mug]

        XCTAssertEqual(offer.amountByProduct(products: products), [
            voucher: 2,
            mug: 2,
            mug2: 1
        ])
    }

    func test_offer_returnsDiscountOfRepeatedProducts() throws {
        let offer = TwoForOneOffer()

        let products = [voucher, voucher, mug, mug2, mug]

        XCTAssertEqual(offer.discount(over:products), 12.5)
    }

    func test_offer_returnsDiscountForTuplesOfRepeatedProducts() throws {
        let offer = TwoForOneOffer()

        let products = [voucher, voucher, voucher, mug, mug2, mug]

        XCTAssertEqual(offer.discount(over:products), 12.5)
    }
}
