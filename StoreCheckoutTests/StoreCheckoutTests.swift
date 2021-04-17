//
//  StoreCheckoutTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

struct Product: Codable {
    let code: String
    let name: String
    let price: Float
}

struct Products: Codable {
    let products: [Product]
}

protocol DataRepository {
    func retrieveProducts() -> [Product]
}

class StubCodableInMemoryDataRepositoryImplementation: DataRepository {
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

    func retrieveProducts() -> [Product] {
        let data = json.data(using: .utf8)!
        let products: Products = try! JSONDecoder()
            .decode(Products.self, from: data)
        return products.products
    }
}


import XCTest
@testable import StoreCheckout

class StoreCheckoutTests: XCTestCase {

    func test_products_decodeWhenValid() throws {
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
        let products: Products = try! JSONDecoder()
            .decode(Products.self, from: data)

        XCTAssertEqual(products.products.count, 3)
    }

    func test_repository_decodeWhenValid() throws {
        let repository: DataRepository = StubCodableInMemoryDataRepositoryImplementation()

        XCTAssertEqual(repository.retrieveProducts().count, 3)
    }

//    // MARK: Helpers
//    func createSUT() -> ([Product]){
//
//    }

}
