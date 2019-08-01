//
//  WishlistViewController.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


protocol BuyCellButtonTapped: class {
    func addProductToBasket(_ sender: SavedViewTableViewCell)
}

class WishlistViewController: UIViewController, BuyCellButtonTapped {

    //Views
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noProductsLabel: UILabel!

    //Variables
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCellConfiguration()
        noProductsLabelObserver()
    }


    // MARK: - RxSwift setup
    func setupCellConfiguration() {
        SavedProducts.wishlistProductsObservable
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "savedCell",
                       cellType: SavedViewTableViewCell.self)) { row, product, cell in
                        cell.configureWithProduct(product: product)

                        cell.delegate = self

            }
            .disposed(by: disposeBag)
    }

    func noProductsLabelObserver(){

        SavedProducts.wishlistProductsObservable.asObservable()
        .subscribe(onNext: { [unowned self] products in

            if products.count > 0{
                self.noProductsLabel.alpha = 0.0
            }else{
                self.noProductsLabel.alpha = 1.0
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - Actions
    func addProductToBasket(_ sender: SavedViewTableViewCell) {
        Haptic.feedBack()
        guard let indexPath = tableView.indexPath(for: sender) else{return}

        var savedArray = SavedProducts.wishlistProductsObservable.value
        let product = SavedProducts.wishlistProductsObservable.value[indexPath.row]
        var basketArray = SavedProducts.basketProductsObservable.value

        if (product.stock ?? 0) > 0{

            //Firstly let's check if item is already in the basket. If it is let's just increase the quantity count in the basket instead of adding a new instance of the product.

            if basketArray.contains(where: {$0.productId == product.productId}) {
                if let index = basketArray.firstIndex(where: {$0.productId == product.productId}){
                    basketArray[index].quantity =  (basketArray[index].quantity ?? 1) + 1
                }
                SavedProducts.basketProductsObservable.accept(basketArray)
            }else{
                SavedProducts.basketProductsObservable.accept(basketArray + [product])

            }
            savedArray.remove(at: indexPath.row)
            SavedProducts.wishlistProductsObservable.accept(savedArray)
        }else{
            UIAlertController.show("Sorry", message: "This item is out of stock", from: self)
        }
    }
}

extension WishlistViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //let product = SavedProducts.savedProductsObservable.value[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction.init(style:.destructive, title: "Remove", handler: { (action, view, completion) in

            var savedArray = SavedProducts.wishlistProductsObservable.value
            Haptic.feedBack()
            savedArray.remove(at: indexPath.row)
            SavedProducts.wishlistProductsObservable.accept(savedArray)

        })

        deleteAction.backgroundColor = UIColor.primaryColour

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config

    }
}


