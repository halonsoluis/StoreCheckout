//
//  DataRepositoryTests.swift
//  DataRepositoryTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

struct StoreProduct: Equatable {
    let code: String
    let name: String
    let price: Float
}

protocol DataRepository {
    func retrieveProducts() -> [StoreProduct]
}

class InMemoryDataRepositoryImplementation: DataRepository {
    func retrieveProducts() -> [StoreProduct] {
        return []
    }
}

import XCTest
@testable import StoreCheckout

class DataRepositoryTests: XCTestCase {

    func test_repository_returnsEmptyWhenNoProducts() throws {
        let repository = createSUT()

        XCTAssertEqual(repository.retrieveProducts(), [])
    }

    // MARK: Helpers

    func createSUT() -> DataRepository {
        let repository = InMemoryDataRepositoryImplementation()
        return repository
    }
}
