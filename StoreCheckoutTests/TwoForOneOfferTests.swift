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
        assert(discount: TwoForOneOffer(), for: [], is: 0)
    }

    func test_offer_returnsZeroOnDifferentProducts() throws {
        assert(discount: TwoForOneOffer(), for: [voucher, tShirt, mug], is: 0)
    }

    func test_offer_returnsDiscountOfRepeatedProducts() throws {
        assert(discount: TwoForOneOffer(), for: [voucher, voucher, mug, mug2, mug], is: 12.5)
    }

    func test_offer_returnsDiscountForTuplesOfRepeatedProducts() throws {
        assert(discount: TwoForOneOffer(), for: [voucher, voucher, voucher, mug, mug2, mug], is: 12.5)
    }

    // MARK: - Helpers

    func assert(discount: Offer, for products: [StoreProduct], is finalPrice: Float, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(discount.discount(over:products), finalPrice, file: file, line: line)
    }
}
