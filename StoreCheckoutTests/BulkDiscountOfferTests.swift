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

    init(minimumAmount: Int = 3, ofItemWithCode code: String = "TSHIRT", newPrice: Float = 19) {
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
    let mug2 = StoreProduct(code: "MUG-2", name: "Coffee Mug", price: 7.5)

    func test_offer_returnsNoDiscountOnEmptyBasket() throws {
        assert(discount: BulkDiscount(minimumAmount: 3), for: [], is: 0)
    }

    func test_offer_returnsZeroOnDifferentProducts() throws {
        assert(discount: BulkDiscount(minimumAmount: 3), for: [voucher, tShirt, mug], is: 0)
    }

    func test_offer_returnsZeroWhenRepeatedProductsAmountIsNotOVerTheMinimum() throws {
        assert(discount: BulkDiscount(minimumAmount: 3), for: [voucher, voucher, mug, mug2, mug], is: 0)
    }

    func test_offer_returnsDiscountOfRepeatedProducts() throws {
        assert(discount: BulkDiscount(minimumAmount: 3), for: [tShirt, tShirt, tShirt], is: 3)
    }
//
//    func test_offer_returnsDiscountForTuplesOfRepeatedProducts() throws {
//        assert(discount: BulkDiscount(minimumAmount: 3), for: [voucher, voucher, voucher, mug, mug2, mug], is: 12.5)
//    }

    // MARK: - Helpers

    func assert(discount: Offer, for products: [StoreProduct], is finalPrice: Float, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(discount.discount(over:products), finalPrice, file: file, line: line)
    }

}
