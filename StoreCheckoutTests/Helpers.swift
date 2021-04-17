//
//  Helpers.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 18/04/2021.
//

import Foundation
import XCTest
@testable import StoreCheckout

extension XCTestCase {

    var voucher: StoreProduct {
        StoreProduct(code: "VOUCHER", name: "Voucher", price: 5)
    }
    var tShirt: StoreProduct {
        StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20)
    }
    var mug: StoreProduct {
        StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)
    }

    func retrieveProducts(from repository: DataRepository, timeout: TimeInterval) -> [StoreProduct] {
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
