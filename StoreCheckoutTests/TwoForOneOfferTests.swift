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
        let uniqueProducts = Array(Set(products))
        var repeatedProducts = products
        uniqueProducts.forEach { product in
            if let index = repeatedProducts.firstIndex(of: product) {
                repeatedProducts.remove(at: index)
            }
        }
        return repeatedProducts.map(\.price).reduce(0, +)
    }
}

class TwoForOneOfferTests: XCTestCase {

    func test_offer_returnsNoDiscountOnEmptyBasket() throws {
        let offer = TwoForOneOffer()

        XCTAssertEqual(offer.discount(over: []), 0)
    }

    func test_offer_returnsZeroOnDifferentProducts() throws {
        let offer = TwoForOneOffer()
        let products = [
            StoreProduct(code: "VOUCHER", name: "Voucher", price: 5),
            StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20),
            StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)
        ]
        XCTAssertEqual(offer.discount(over:products), 0)
    }

    func test_offer_returnsFullPriceOfRepeatedProducts() throws {
        let offer = TwoForOneOffer()
        let products = [
            StoreProduct(code: "VOUCHER", name: "Voucher", price: 5),
            StoreProduct(code: "VOUCHER", name: "Voucher", price: 5),
            StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5),
            StoreProduct(code: "MUG-2", name: "Coffee Mug", price: 7.5),
            StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)
        ]
        XCTAssertEqual(offer.discount(over:products), 12.5)
    }
}
