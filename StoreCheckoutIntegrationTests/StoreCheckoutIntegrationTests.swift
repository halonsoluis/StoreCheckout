//
//  StoreCheckoutIntegrationTests.swift
//  StoreCheckoutIntegrationTests
//
//  Created by Hugo Alonso on 18/04/2021.
//

import XCTest
@testable import StoreCheckout

class StoreCheckoutIntegrationTests: XCTestCase {

    func test_availableProducts_areLoadedFromRemote() {
        let client = URLSessionHTTPClient()
        let sut: DataRepository = DataRepositoryImplementation(client: client)

        let receivedProducts = retrieveProducts(from: sut)

        XCTAssertEqual(receivedProducts.count, 3)
        XCTAssertEqual(receivedProducts.map(\.code), ["VOUCHER", "TSHIRT", "MUG"])
    }

    func test_productCost_appliesDiscountWhithTwoForOneOffer() throws {
        let offer = TwoForOneOffer(discountedProduct: ["VOUCHER"])
        let sut = createSUT(
            offers: [ offer ],
            products: [
                Products.voucher,
                Products.voucher,
                Products.tShirt,
                Products.mug
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
                Products.voucher,
                Products.voucher,
                Products.tShirt,
                Products.mug
            ]
        )

        XCTAssertEqual(sut.costBeforeReductions, 37.5)
        XCTAssertEqual(sut.costAfterReductions, 33.5, accuracy: 0.001)
        XCTAssertEqual(sut.applicableOffers, [offer.name])
    }

    func test_checkout_returnFinalCostWhenApplyingBothOffers() {
        let twoForOneOffer = TwoForOneOffer(discountedProduct: ["VOUCHER"])
        let bulkOffer = BulkDiscount(
            config: [BulkDiscount.Config(code: "TSHIRT", newPrice: 19, minimumAmount: 3)]
        )
        let sut = createSUT(
            offers: [ twoForOneOffer, bulkOffer ],
            products: [
                Products.voucher,
                Products.tShirt,
                Products.mug
            ]
        )

        //        Items: VOUCHER, TSHIRT, MUG
        //        Total: 32.50€
        XCTAssertEqual(sut.costAfterReductions, 32.5, accuracy: 0.001)


//
//        Items: VOUCHER, TSHIRT, VOUCHER
//        Total: 25.00€
//
//        Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
//        Total: 81.00€
//
//        Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
//        Total: 74.50€

    }

    //MARK: Helpers

    struct Products {
        static let voucher = StoreProduct(code: "VOUCHER", name: "Voucher", price: 5)
        static let tShirt = StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20)
        static let mug = StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)
    }

    private func createSUT(offers: [Offer], products: [StoreProduct]) -> Checkout {
        Checkout(products: products, offers: offers)
    }

    private func retrieveProducts(from repository: DataRepository, timeout: TimeInterval = 5) -> [StoreProduct] {
        var retrievedProducts: [StoreProduct] = []
        let expect = expectation(description: "Waiting for expectation")
        repository.retrieveProducts { (products) in
            retrievedProducts = products
            expect.fulfill()
        }
        wait(for: [expect], timeout: timeout)
        return retrievedProducts
    }

}
