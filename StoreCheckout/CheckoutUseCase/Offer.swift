//
//  Offer.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

protocol Offer {
    func discount(over: [StoreProduct]) -> Float
}
