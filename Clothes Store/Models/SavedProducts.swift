//
//  SavedProducts.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SavedProducts{

    static var wishlistProductsObservable : BehaviorRelay<[Product]> = BehaviorRelay(value: [])
    static var basketProductsObservable : BehaviorRelay<[Product]> = BehaviorRelay(value: [])
}


