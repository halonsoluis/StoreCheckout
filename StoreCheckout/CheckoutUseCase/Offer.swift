//
//  Offer.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

protocol Offer {
    var name: String { get }
    
    func discount(over: [StoreProduct]) -> Float
}
