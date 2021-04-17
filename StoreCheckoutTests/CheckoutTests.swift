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
        return 0
    }

    var costAfterReductions: Float {
        return 0
    }
}

class CheckoutTests: XCTestCase {

    func test_zeroCost_whenNoProducts() throws {
        let checkout = Checkout(products: [], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 0)
        XCTAssertEqual(checkout.costAfterReductions, 0)
    }
}
