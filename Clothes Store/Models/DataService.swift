//
//  DataService.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import Foundation

import Alamofire

class DataService {

    class func getProducts(completion: @escaping (Products?, Error?) -> Void) {

        Alamofire.request(URLCall.catalogue.rawValue)
            .validate()
            .responseProducts { response in

                switch response.result {
                case .success:

                    guard let data = response.data else{return}

                    let products = try? JSONDecoder().decode(Products.self, from: data)
                    completion(products, nil)

                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    //This call does not work correctly as the product returned is not what the productID submitted is
    class func getProduct(productID: Int, completion: @escaping (Product?, Error?) -> Void) {

        Alamofire.request(URLCall.product.rawValue + "/\(productID)")
            .validate()
            .responseProduct { response in

                switch response.result {
                case .success:

                    guard let data = response.data else{return}

                    let products = try? JSONDecoder().decode(Product.self, from: data)
                    completion(products, nil)

                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    class func addToBasket(productID: Int, completion: @escaping (Cart?, Error?) -> Void) {

        let parameters : Parameters = ["productId" : productID]
        let  url = URL(string: URLCall.cart.rawValue)!

        Alamofire.request(urlRequestWithType(url, type: .post, parameters: parameters))
            .validate()
            .responseCart { response in

                switch response.result {
                case .success:

                    guard let data = response.data else{return}

                    let products = try? JSONDecoder().decode(Cart.self, from: data)
                    completion(products, nil)

                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    class func removeFromBasket(productID: Int, completion: @escaping (Bool) -> Void) {

        Alamofire.request(URLCall.cart.rawValue + "/\(productID)")
            .validate(statusCode: 200...204)
            .responseData { response in

                switch response.result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
        }
    }

    class func urlRequestWithType(_ url: URL, type: HTTPMethod, parameters: Parameters) -> URLRequest {

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do{
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = data
        }catch{

        }


        return urlRequest
    }


}
