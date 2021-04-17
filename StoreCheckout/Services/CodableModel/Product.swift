//
//  Product.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//
import Foundation

struct Product: Codable, Equatable {
    let code: String
    let name: String
    let price: Float
}
