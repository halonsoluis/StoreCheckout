//
//  DataRepositoryImplementation.swift
//  StoreCheckout
//
//  Created by Hugo Alonso on 17/04/2021.
//

import Foundation

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
        return box.asStoreProducts()
    }
}

extension Products {
    func asStoreProducts() -> [StoreProduct] {
        return self.products.map(StoreProduct.init)
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
