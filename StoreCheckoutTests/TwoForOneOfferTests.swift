//
//  TwoForOneOfferTests.swift
//  StoreCheckoutTests
//
//  Created by Hugo Alonso on 17/04/2021.
//

import XCTest
@testable import StoreCheckout

class TwoForOneOffer: Offer {
    func discount(over: [StoreProduct]) -> Float {
        return 0
    }
}

class TwoForOneOfferTests: XCTestCase {

    func test_offer_returnsNoDiscountOnEmptyBasket() throws {
        let offer = TwoForOneOffer()

        XCTAssertEqual(offer.discount(over: []), 0)
    }
}
