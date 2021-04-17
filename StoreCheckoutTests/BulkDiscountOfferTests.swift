//
//  BulkDiscountOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class BulkDiscount: Offer {
    private let minimumAmount: Int
    private let newPrice: Float
    private let code: String

    init(minimumAmount: Int, ofItemWithCode code: String, newPrice: Float) {
        self.minimumAmount = minimumAmount
        self.newPrice = newPrice
        self.code = code
    }

    func discount(over products: [StoreProduct]) -> Float {
        let discountedItem = products.filter { $0.code == code }

        guard discountedItem.count >= minimumAmount else {
            return 0
        }

        let originalPrice = discountedItem[0].price
        let discountPerItem = originalPrice - newPrice

        return Float(discountedItem.count) * discountPerItem
    }
}

class BulkDiscountOfferTests: XCTestCase {

    let voucher = StoreProduct(code: "VOUCHER", name: "Voucher", price: 5)
    let tShirt = StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20)
    let mug = StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)

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

    // MARK: - Helpers

    func assert(discount: Offer, for products: [StoreProduct], is finalPrice: Float, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(discount.discount(over:products), finalPrice, file: file, line: line)
    }

    func createSUT() -> Offer {
        BulkDiscount(minimumAmount: 3, ofItemWithCode: "TSHIRT", newPrice: 19)
    }

}
