//
//  StoreCheckoutIntegrationTests.swift
//  StoreCheckoutIntegrationTests
//
//  Created by Hugo Alonso on 18/04/2021.
//

import XCTest
import StoreCheckout

public final class URLSessionHTTPClient: HTTPClient {
    let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedValues: Error {}

    public func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValues()))
            }
        }.resume()
    }
}

class StoreCheckoutIntegrationTests: XCTestCase {

    func test_availableProducts_areLoadedFromRemote() {
        let client = URLSessionHTTPClient()
        let sut: DataRepository = DataRepositoryImplementation(client: client)

        let receivedProducts = retrieveProducts(from: sut)

        XCTAssertEqual(receivedProducts.count, 3)
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
