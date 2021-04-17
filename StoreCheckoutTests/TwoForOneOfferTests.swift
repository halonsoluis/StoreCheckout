//
//  TwoForOneOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class TwoForOneOffer: Offer {
    func discount(over: [StoreProduct]) -> Float {
        return 0
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
}
