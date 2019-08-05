//
//  BasketViewController.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasketViewController: UIViewController {
    
    //Views
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noProductsLabel: UILabel!
    @IBOutlet var total: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    //Variables
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        checkoutButton.dropShadow(radius: 8, opacity: 0.4, color: UIColor.primaryColour)
        setupCellConfiguration()
        labelsObserver()
    }

    // MARK: - RxSwift setup
    func setupCellConfiguration() {
        SavedProducts.basketProductsObservable
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "basketCell",
                       cellType: BasketViewTableViewCell.self)) { row, product, cell in
                        cell.configureWithProduct(product: product)

            }
            .disposed(by: disposeBag)
    }

    func labelsObserver(){

        SavedProducts.basketProductsObservable.asObservable()
            .subscribe(onNext: { [unowned self] products in

                if products.count > 0{
                    self.noProductsLabel.alpha = 0.0
                }else{
                    self.noProductsLabel.alpha = 1.0
                }

                let total = products.map({($0.price ?? 0.0) * Float($0.quantity ?? 0)}).reduce(Float(0.0), +)

                self.total.text = CurrencyHelper.getMoneyString(total)
            }).disposed(by: disposeBag)
    }
}

extension BasketViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //let product = SavedProducts.savedProductsObservable.value[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction.init(style:.destructive, title: "Remove", handler: { (action, view, completion) in

            var savedArray = SavedProducts.basketProductsObservable.value
            Haptic.feedBack()

            if savedArray[indexPath.row].quantity ?? 1 > 1{
                savedArray[indexPath.row].quantity = (savedArray[indexPath.row].quantity ?? 1) - 1
                SavedProducts.basketProductsObservable.accept(savedArray)
            }else{

            savedArray.remove(at: indexPath.row)
            SavedProducts.basketProductsObservable.accept(savedArray)
            }
        })

        deleteAction.backgroundColor = UIColor.primaryColour

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config

    }

}

