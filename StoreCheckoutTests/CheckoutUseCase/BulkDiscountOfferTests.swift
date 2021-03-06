//
//  BulkDiscountOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class BulkDiscountOfferTests: XCTestCase {

    static let tShirtDiscount = BulkDiscount.Config(code: "TSHIRT", newPrice: 19, minimumAmount: 3)

    func test_offer_returnsNoDiscountOnEmptyBasket() throws {
        assert(discount: createSUT(), for: [], is: 0)
    }

    func test_offer_returnsZeroOnDifferentProducts() throws {
        assert(discount: createSUT(), for: [voucher, tShirt, mug], is: 0)
    }

    func test_offer_returnsZeroWhenRepeatedProductsAmountIsNotOverTheMinimum() throws {
        assert(discount: createSUT(), for: [tShirt, tShirt, voucher, voucher, voucher, mug, mug, mug], is: 0)
    }

    func test_offer_returnsDiscountOfTheMinimumOfRepeatedProducts() throws {
        assert(discount: createSUT(), for: [tShirt, tShirt, tShirt], is: 3)
    }

    func test_offer_returnsDiscountForMoreThanTheMinimumOfRepeatedProducts() throws {
        assert(discount: createSUT(), for: [tShirt, tShirt, tShirt, tShirt, tShirt, tShirt], is: 6)
    }

    func test_severalOffers_returnDiscountForMoreThanTheMinimumOfRepeatedProducts() throws {
        let tShirtDiscount = BulkDiscount.Config(code: "TSHIRT", newPrice: 19, minimumAmount: 3)
        let voucherDiscount = BulkDiscount.Config(code: "VOUCHER", newPrice: 3, minimumAmount: 2)

        assert(
            discount: createSUT(discounts: [tShirtDiscount, voucherDiscount]),
            for: [tShirt, tShirt, voucher, voucher, voucher, mug, mug, mug],
            is: 6
        )
    }

    // MARK: - Helpers

    func assert(discount: Offer, for products: [StoreProduct], is finalPrice: Float, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(discount.discount(over:products), finalPrice, file: file, line: line)
    }

    func createSUT(discounts: [BulkDiscount.Config] = [tShirtDiscount]) -> Offer {
        return BulkDiscount(config: discounts)
    }

}
