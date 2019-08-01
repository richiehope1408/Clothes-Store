//
//  Product
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import Foundation
import Foundation
import Alamofire

// MARK: - Product
struct Product: Codable, Equatable, Hashable  {
    let productId: Int?
    let name, category: String?
    let price: Float?
    let oldPrice: Float?
    let stock: Int?
    var quantity: Int? = 0
    
    init(productId: Int?, name: String?, category: String?, price: Float?, oldPrice: Float?, stock: Int?, quantity: Int) {
        self.productId = productId
        self.name = name
        self.category = category
        self.price = price
        self.oldPrice = oldPrice
        self.stock = stock
        self.quantity = quantity
    }
}

typealias Products = [Product]

// MARK: - Cart
struct Cart: Codable {
    let cartId, productId: Int?
}


// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    //Products Array
    @discardableResult
    func responseProducts(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Products>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }

    //Single Product
    @discardableResult
    func responseProduct(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Product>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }

    //Cart
    @discardableResult
    func responseCart(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Cart>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

