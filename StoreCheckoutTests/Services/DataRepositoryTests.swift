//
//  DataRepositoryTests.swift
//  DataRepositoryTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class DataRepositoryTests: XCTestCase {

    func test_repository_returnsEmptyOnError() throws {
        let (repository, httpSpy) = createSUT()
        httpSpy.returnedError = NSError(domain: "AnyDomain", code: -23, userInfo: nil)

        let products = retrieveProducts(from: repository)

        XCTAssertEqual(products, [])
    }

    func test_repository_returnsEmptyOnParseError() throws {
        let (repository, httpSpy) = createSUT()
        httpSpy.returnedJSON = [
            "not a valid json": []
        ]

        let products = retrieveProducts(from: repository)

        XCTAssertEqual(products, [])
    }


    func test_repository_returnsProductsWhenReachingEndpoint() throws {
        let (repository, httpSpy) = createSUT()
        httpSpy.returnedJSON =
            [
            "products": [
              [
                "code": "VOUCHER",
                "name": "Voucher",
                "price": 5
              ],
              [
                "code": "TSHIRT",
                "name": "T-Shirt",
                "price": 20
              ],
              [
                "code": "MUG",
                "name": "Coffee Mug",
                "price": 7.5
              ]
            ]
        ]

        let products = retrieveProducts(from: repository)

        XCTAssertEqual(products, [
            StoreProduct(code: "VOUCHER", name: "Voucher", price: 5),
            StoreProduct(code: "TSHIRT", name: "T-Shirt", price: 20),
            StoreProduct(code: "MUG", name: "Coffee Mug", price: 7.5)
        ])
    }

    // MARK: Helpers

    func createSUT() -> (DataRepository, HTTPClientSpy) {
        let httpSpy = HTTPClientSpy()
        let repository = DataRepositoryImplementation(client: httpSpy)
        return (repository, httpSpy)
    }

    func retrieveProducts(from repository: DataRepository) -> [StoreProduct] {
        var retrievedProducts: [StoreProduct] = []
        let expect = expectation(description: "Waiting for expectation")
        repository.retrieveProducts { (products) in
            retrievedProducts = products
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1)
        return retrievedProducts
    }

    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var returnedJSON: [String: Any]?
        var returnedError: Error?
        var returnedStatusCode: Int = 200

        func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
            requestedURL = url

            if let returnedError = returnedError {
                completion(.failure(returnedError))
                return
            }

            if let returnedJSON = returnedJSON {
                let data = try! JSONSerialization.data(withJSONObject: returnedJSON)
                let response = HTTPURLResponse(
                    url: url,
                    statusCode: returnedStatusCode,
                    httpVersion: nil,
                    headerFields: nil
                )!
                completion(.success((data, response)))
            }
        }
    }
}
