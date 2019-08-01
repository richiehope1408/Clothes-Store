//
//  Constants.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import Foundation
import UIKit

enum URLCall : String {
    case catalogue = "https://private-anon-5686d8c23e-ddshop.apiary-mock.com/products"
    case product = "https://private-anon-5686d8c23e-ddshop.apiary-mock.com/products/"
    case cart = "https://private-anon-5686d8c23e-ddshop.apiary-mock.com/cart"
}

extension UIColor{

    class var primaryColour: UIColor{
        return #colorLiteral(red: 1, green: 0.3348520994, blue: 0.4051724672, alpha: 1)
    }
}
