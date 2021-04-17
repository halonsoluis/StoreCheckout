//
//  DataRepository.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

public protocol DataRepository {
    func retrieveProducts(onComplete completion: @escaping ([StoreProduct]) -> Void) -> Void
}
