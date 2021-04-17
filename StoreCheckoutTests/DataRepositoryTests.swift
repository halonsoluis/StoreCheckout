//
//  DataRepositoryTests.swift
//  DataRepositoryTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

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
