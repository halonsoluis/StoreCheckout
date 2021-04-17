//
//  ProductAsCodableTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//
import XCTest
@testable import StoreCheckout

class ProductAsCodableTests: XCTestCase {

    func test_json_decodeProductsWhenValid() throws {
        let json = """
        {
            "products": [
              {
                "code": "VOUCHER",
                "name": "Voucher",
                "price": 5
              },
              {
                "code": "TSHIRT",
                "name": "T-Shirt",
                "price": 20
              },
              {
                "code": "MUG",
                "name": "Coffee Mug",
                "price": 7.5
              }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let expectedProducts = [
            Product(code: "VOUCHER", name: "Voucher", price: 5),
            Product(code: "TSHIRT", name: "T-Shirt", price: 20),
            Product(code: "MUG", name: "Coffee Mug", price: 7.5)
        ]

        let products: Products = try! JSONDecoder()
            .decode(Products.self, from: data)

        XCTAssertEqual(products.products, expectedProducts)
    }

}
