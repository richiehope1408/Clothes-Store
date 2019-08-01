//
//  TabBarController.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2018 Richard Hope. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarController: UITabBarController {

    //Views
    var tabItem : UITabBarItem?

    //Variables
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SavedProducts.basketProductsObservable.asObservable()
            .subscribe(onNext: { [unowned self] products in
                
                if products.count > 0{
                    let qty = products.map({$0.quantity ?? 1}).reduce(0, +)
                    self.tabItem?.badgeValue = "\(qty)"
                }else{
                    self.tabItem?.badgeValue = nil
                }
            }).disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let tabItems = tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            tabItem = tabItems[2]
        }

    }
}
