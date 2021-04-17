//
//  DataRepositoryTests.swift
//  DataRepositoryTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

class DataRepositoryImplementation: DataRepository {
    let client: HTTPClient
    let downloadURL = URL(string: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json")!

    init(client: HTTPClient) {
        self.client = client
    }

    func retrieveProducts(onComplete completion: @escaping ([StoreProduct]) -> Void) -> Void {
        _ = client.get(from: downloadURL) { result in
            switch result {
            case .failure: completion([])
            case .success(let (data,_)):
                completion(Self.parse(from: data))
            }
        }
    }

    private static func parse(from data: Data) -> [StoreProduct] {
        guard let box = try? JSONDecoder().decode(Products.self, from: data) else {
            return []
        }
        return box.products.asStoreProducts()
    }
}

extension Array where Element == Product {
    func asStoreProducts() -> [StoreProduct] {
        return self.map(StoreProduct.init)
    }
}

extension StoreProduct {
    init(product: Product) {
        self.init(
            code: product.code,
            name: product.name,
            price: product.price
        )
    }
}

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
                completion(.success((data, HTTPURLResponse(url: url, statusCode: returnedStatusCode, httpVersion: nil, headerFields: nil)!)))
            }
        }
    }
}
