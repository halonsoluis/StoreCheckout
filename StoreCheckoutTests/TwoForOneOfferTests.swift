//
//  TwoForOneOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

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
