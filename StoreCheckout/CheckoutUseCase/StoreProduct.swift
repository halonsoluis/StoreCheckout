//
//  StoreProduct.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

public struct StoreProduct: Equatable, Hashable {
    public let code: String
    public let name: String
    public let price: Float
}
