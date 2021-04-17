//
//  StoreCheckoutIntegrationTests.swift
//  StoreCheckoutIntegrationTests
//
//  Created by Hugo Alonso on 18/04/2021.
//

import XCTest
import StoreCheckout

class StoreCheckoutIntegrationTests: XCTestCase {

    func test_availableProducts_areLoadedFromRemote() {
        let client = URLSessionHTTPClient()
        let sut: DataRepository = DataRepositoryImplementation(client: client)

        let receivedProducts = retrieveProducts(from: sut, timeout: 5)

        XCTAssertEqual(receivedProducts.count, 3)
        XCTAssertEqual(receivedProducts.map(\.code), ["VOUCHER", "TSHIRT", "MUG"])
    }

    func test_productCost_appliesDiscountWhithTwoForOneOffer() throws {
        let offer = TwoForOneOffer(discountedProduct: ["VOUCHER"])
        let sut = createSUT(
            offers: [ offer ],
            products: [
                voucher,
                voucher,
                tShirt,
                mug
            ]
        )

        XCTAssertEqual(sut.costBeforeReductions, 37.5)
        XCTAssertEqual(sut.costAfterReductions, 32.5, accuracy: 0.001)
        XCTAssertEqual(sut.applicableOffers, [offer.name])
    }

    func test_productCost_appliesDiscountWhithBulkVoucherOffer() throws {
        let offer = BulkDiscount(
            config: [BulkDiscount.Config(code: "VOUCHER", newPrice: 3, minimumAmount: 2)]
        )
        let sut = createSUT(
            offers: [ offer ],
            products: [
                voucher,
                voucher,
                tShirt,
                mug
            ]
        )

        XCTAssertEqual(sut.costBeforeReductions, 37.5)
        XCTAssertEqual(sut.costAfterReductions, 33.5, accuracy: 0.001)
        XCTAssertEqual(sut.applicableOffers, [offer.name])
    }

    func test_checkout_returnFinalCostWhenApplyingBothOffers() {
        //        Items: VOUCHER, TSHIRT, MUG
        //        Total: 32.50€
        assertFinalPriceWhenTwoOffersAdded(
            for: [ voucher, tShirt, mug ],
            is: 32.5
        )

        //        Items: VOUCHER, TSHIRT, VOUCHER
        //        Total: 25.00€
        assertFinalPriceWhenTwoOffersAdded(
            for: [ voucher, tShirt, voucher ],
            is: 25
        )

        //        Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
        //        Total: 81.00€

        assertFinalPriceWhenTwoOffersAdded(
            for: [
                tShirt,
                tShirt,
                tShirt,
                voucher,
                tShirt
            ],
            is: 81
        )

        //        Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
        //        Total: 74.50€
        assertFinalPriceWhenTwoOffersAdded(
            for: [
                voucher,
                tShirt,
                voucher,
                voucher,
                mug,
                tShirt,
                tShirt
            ],
            is: 74.50
        )
    }

    //MARK: Helpers

    private func createSUT(offers: [Offer], products: [StoreProduct]) -> Checkout {
        CheckoutImplementation(products: products, offers: offers)
    }

    func assertFinalPriceWhenTwoOffersAdded(for products: [StoreProduct], is finalPrice: Float, file: StaticString = #file, line: UInt = #line) {

        let twoForOneOffer = TwoForOneOffer(discountedProduct: ["VOUCHER"])
        let bulkOffer = BulkDiscount(
            config: [BulkDiscount.Config(code: "TSHIRT", newPrice: 19, minimumAmount: 3)]
        )
        let sut = createSUT(
            offers: [ twoForOneOffer, bulkOffer ],
            products: products
        )

        XCTAssertEqual(sut.costAfterReductions, finalPrice, accuracy: 0.001, file: file, line: line)
    }

}
