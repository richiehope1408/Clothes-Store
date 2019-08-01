//
//  CurrencyHelpers.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import Foundation

class CurrencyHelper {

    class func getMoneyString(_ value: Float) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        return currencyFormatter.string(from: NSNumber(value: value)) ?? "0"
    }
}
