//
//  CheckoutTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class CheckoutTests: XCTestCase {
    let voucher = StoreProduct(code: "VOUCHER", name: "Voucher", price: 5)
    let tShirt = StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20)
    let mug = StoreProduct(code: "MUG", name: "Coffee Mug", price: 6)

    func test_zeroCost_whenNoProducts() throws {
        let checkout = Checkout(products: [], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 0)
        XCTAssertEqual(checkout.costAfterReductions, 0)
    }

    func test_productCost_whenNoOffers() throws {
        let checkout = Checkout(products: [voucher, tShirt, mug], offers: [])

        XCTAssertEqual(checkout.costBeforeReductions, 31)
        XCTAssertEqual(checkout.costAfterReductions, 31)
        XCTAssertEqual(checkout.applicableOffers, [])
    }

    func test_productCost_appliesDiscountWhenOfferApply() throws {
        let offer = DummyOffer()
        let checkout = Checkout(products: [voucher, tShirt, mug], offers: [offer])

        XCTAssertEqual(checkout.costBeforeReductions, 31.0)
        XCTAssertEqual(checkout.costAfterReductions, 30.0, accuracy: 0.001)
        XCTAssertEqual(checkout.applicableOffers, [offer.name])
    }

    // Integration Test
    func test_productCost_appliesDiscountWhithTwoForOneOffer() throws {
        let offer = TwoForOneOffer(discountedProduct: ["VOUCHER"])
        let checkout = Checkout(products: [voucher, voucher, tShirt, mug], offers: [offer])

        XCTAssertEqual(checkout.costBeforeReductions, 36.0)
        XCTAssertEqual(checkout.costAfterReductions, 31.0, accuracy: 0.001)
        XCTAssertEqual(checkout.applicableOffers, [offer.name])
    }

    // Integration Test
    func test_productCost_appliesDiscountWhithBulkVoucherOffer() throws {
        let offer = BulkDiscount(
            config: [BulkDiscount.Config(code: "VOUCHER", newPrice: 3, minimumAmount: 2)]
        )
        let checkout = Checkout(products: [voucher, voucher, tShirt, mug], offers: [offer])

        XCTAssertEqual(checkout.costBeforeReductions, 36.0)
        XCTAssertEqual(checkout.costAfterReductions, 32.0, accuracy: 0.001)
        XCTAssertEqual(checkout.applicableOffers, [offer.name])
    }

    struct DummyOffer: Offer {
        let name: String = "-1"

        var appliedDiscount = 1

        func discount(over: [StoreProduct]) -> Float {
            return Float(appliedDiscount)
        }
    }
}

extension Array where Element: Offer {
    func equals(other: [Offer]) -> Bool {
        self.map(\.name) == other.map(\.name)
    }
}
