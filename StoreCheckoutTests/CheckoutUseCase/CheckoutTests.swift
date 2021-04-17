//
//  CheckoutTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class CheckoutTests: XCTestCase {
    func test_zeroCost_whenNoProducts() throws {
        let checkout = createSUT(products: [], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 0)
        XCTAssertEqual(checkout.costAfterReductions, 0)
    }

    func test_productCost_whenNoOffers() throws {
        let checkout = createSUT(products: [voucher, tShirt, mug], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 32.5)
        XCTAssertEqual(checkout.costAfterReductions, 32.5)
        XCTAssertEqual(checkout.applicableOffers, [])
    }

    func test_productCost_appliesDiscountWhenOfferApply() throws {
        let offer = DummyOffer()
        let checkout = createSUT(products: [voucher, tShirt, mug], offers: [offer])

        XCTAssertEqual(checkout.costBeforeReductions, 32.5)
        XCTAssertEqual(checkout.costAfterReductions, 31.5, accuracy: 0.001)
        XCTAssertEqual(checkout.applicableOffers, [offer.name])
    }

    // MARK: - Helpers

    struct DummyOffer: Offer {
        let name: String = "-1"

        var appliedDiscount = 1

        func discount(over: [StoreProduct]) -> Float {
            return Float(appliedDiscount)
        }
    }

    private func createSUT(products: [StoreProduct], offers: [Offer]) -> Checkout {
        CheckoutImplementation(products: products, offers: offers)
    }
}

extension Array where Element: Offer {
    func equals(other: [Offer]) -> Bool {
        self.map(\.name) == other.map(\.name)
    }
}
