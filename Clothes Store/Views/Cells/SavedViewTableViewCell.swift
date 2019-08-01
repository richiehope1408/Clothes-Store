//
//  SavedViewTableViewCell.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import Foundation
import UIKit

class SavedViewTableViewCell: UITableViewCell{

    //Views
    @IBOutlet var cellView: UIView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var addToButton: UIButton!

    //Variables
    weak var delegate : BuyCellButtonTapped?

    func configureWithProduct(product: Product){

        self.productName.text = product.name
        self.productPrice.text = CurrencyHelper.getMoneyString(product.price ?? 0)
        self.cellView.dropShadow(radius: 10, opacity: 0.1, color: .black)

    }

    @IBAction func addToBasket(_ sender: Any) {
        delegate?.addProductToBasket(self)
    }


}
