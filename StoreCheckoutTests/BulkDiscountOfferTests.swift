//
//  BulkDiscountOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class BulkDiscount: Offer {
    struct BulkConfig {
        let code: String
        let newPrice: Float
        let minimumAmount: Int
    }

    private let config: [BulkConfig]

    init(config: [BulkConfig]) {
        self.config = config
    }

    func discount(over products: [StoreProduct]) -> Float {
        config
            .map { (products, $0) }
            .map(applyDiscount)
            .reduce(0, +)
    }

    func applyDiscount(products: [StoreProduct], config: BulkConfig) -> Float {
        let discountedItem = products.filter { $0.code == config.code }

        guard discountedItem.count >= config.minimumAmount else {
            return 0
        }

        let originalPrice = discountedItem[0].price
        let discountPerItem = originalPrice - config.newPrice

        return Float(discountedItem.count) * discountPerItem
    }
}

class BulkDiscountOfferTests: XCTestCase {

    let voucher = StoreProduct(code: "VOUCHER", name: "Voucher", price: 5)
    let tShirt = StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20)
    let mug = StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)

    static let tShirtDiscount = BulkDiscount.BulkConfig(code: "TSHIRT", newPrice: 19, minimumAmount: 3)

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
        let tShirtDiscount = BulkDiscount.BulkConfig(code: "TSHIRT", newPrice: 19, minimumAmount: 3)
        let voucherDiscount = BulkDiscount.BulkConfig(code: "VOUCHER", newPrice: 3, minimumAmount: 2)

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

    func createSUT(discounts: [BulkDiscount.BulkConfig] = [tShirtDiscount]) -> Offer {
        return BulkDiscount(config: discounts)
    }

}
