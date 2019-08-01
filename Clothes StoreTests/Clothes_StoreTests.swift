//
//  Clothes_StoreTests.swift
//  Clothes StoreTests
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import XCTest
@testable import Clothes_Store
import Alamofire

//These test are to check the Network responses mainly.
class Clothes_StoreTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func testGetProductsCallIsSuccessfull() {

        let url = URLCall.catalogue.rawValue
        // 1
        let expectation = self.expectation(description: "Status code: 200")

        var response: DefaultDataResponse?

        // When
        Alamofire.request(url)
            .response { resp in
            response = resp
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        // Then
        XCTAssertEqual(response?.response?.statusCode, 200)

    }

    func testAddToCartCallIsSuccessfull() {

        let url = URLCall.cart.rawValue

        let parameters : Parameters = ["productId":1]
        // 1
        let expectation = self.expectation(description: "Status code: 201")

        var response: DefaultDataResponse?

        // When
        Alamofire.request(url, method: .post, parameters: parameters)
            .response { resp in
                response = resp
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertEqual(response?.response?.statusCode, 201)

    }

    func testRemoveFromCartCallIsSuccessfull() {

        let url = URLCall.cart.rawValue + "/\(1)"

        // 1
        let expectation = self.expectation(description: "Status code: 204")

        var response: DefaultDataResponse?

        // When
        Alamofire.request(url, method: .delete)
            .response { resp in
                response = resp
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertEqual(response?.response?.statusCode, 204)

    }


    func testRetrieveAProductCallIsSuccessfull() {

        let url = URLCall.product.rawValue + "\(2)"

        // 1
        let expectation = self.expectation(description: "Product ID = 2")

        var product: Product?
        // When
        Alamofire.request(url)
            .validate()
            .responseProduct { response in

                guard let data = response.data else{return}

                product = try? JSONDecoder().decode(Product.self, from: data)
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertEqual(product?.productId, 2)
        //This test always fails as no matter what productID is submiited it always returns the productID 1
    }

}
