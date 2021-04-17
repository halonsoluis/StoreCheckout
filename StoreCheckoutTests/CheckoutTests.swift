//
//  CheckoutTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

protocol Offer {
    func discount(over: [StoreProduct]) -> Float
}

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
}

class CheckoutTests: XCTestCase {

    func test_zeroCost_whenNoProducts() throws {
        let checkout = Checkout(products: [], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 0)
        XCTAssertEqual(checkout.costAfterReductions, 0)
    }

    func test_productCost_whenNoOffers() throws {
        let checkout = Checkout(products: [
            StoreProduct(code: "VOUCHER", name: "Voucher", price: 5),
            StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20),
            StoreProduct(code: "MUG", name: "Coffee Mug", price: 6)
        ], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 31)
        XCTAssertEqual(checkout.costAfterReductions, 31)
    }

    func test_productCost_appliesDiscountWhenOfferApply() throws {
        let checkout = Checkout(products: [
            StoreProduct(code: "VOUCHER", name: "Voucher", price: 5),
            StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20),
            StoreProduct(code: "MUG", name: "Coffee Mug", price: 6)
        ], offers: [
            DummyOffer()
        ])

        XCTAssertEqual(checkout.costBeforeReductions, 31.0)
        XCTAssertEqual(checkout.costAfterReductions, 30.0, accuracy: 0.001)
    }

    struct DummyOffer: Offer {
        var appliedDiscount = 1

        func discount(over: [StoreProduct]) -> Float {
            return Float(appliedDiscount)
        }
    }
}
