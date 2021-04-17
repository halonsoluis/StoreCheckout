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

        let receivedProducts = retrieveProducts(from: sut)

        XCTAssertEqual(receivedProducts.count, 3)
        XCTAssertEqual(receivedProducts.map(\.code), ["VOUCHER", "TSHIRT", "MUG"])
    }

    func retrieveProducts(from repository: DataRepository, timeout: TimeInterval = 5) -> [StoreProduct] {
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
