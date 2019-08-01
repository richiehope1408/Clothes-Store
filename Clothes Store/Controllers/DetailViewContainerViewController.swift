//
//  DetailViewContainerViewController.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2019 RichieHope. All rights reserved.
//

import UIKit

class DetailViewContainerViewController: UIViewController{


    //Views
    var backButton : UIBarButtonItem!
    @IBOutlet var wishListButton: UIButton!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var addedToWishlistLabel: UILabel!
    @IBOutlet var addedToBasketLabel: UILabel!

    //Variables
    var product : Product!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }
    
    func setUpButtons(){

        wishListButton.dropShadow(radius: 8, opacity: 0.2, color: .black)
        addToCartButton.dropShadow(radius: 8, opacity: 0.4, color: UIColor.primaryColour)
        addToCartButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: addToCartButton.frame.width - 55, bottom: 5, right: 5)
        wishListButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: wishListButton.frame.width - 55, bottom: 5, right: 5)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailContainer"{
            let dest = segue.destination as! ProductDetailTableViewController
            dest.product = product
        }
    }


    // MARK: - Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartAction(_ sender: Any) {
        Haptic.feedBack()

        if (product.stock ?? 0) > 0{
        //This newtwork call in reality doesn't work as it returns the same data irrespective of the product ID sent
        DataService.addToBasket(productID: product.productId!) { (cart, error) in
            if error != nil{
                UIAlertController.show("Error", message: "There was an error adding your item to your basket.", from: self)
            }else{
                AnimateMe.animateLabel(self.addedToBasketLabel)

                var array = SavedProducts.basketProductsObservable.value

                //Firstly let's check if item is already in the basket. If it is let's just increase the quantity count in the basket instead of adding a new instance of the product.
                if array.contains(where: {$0.productId == self.product.productId}) {


                    if let index = array.firstIndex(where: {$0.productId == self.product.productId}){
                        array[index].quantity =  (array[index].quantity ?? 1) + 1
                    }

                    SavedProducts.basketProductsObservable.accept(array)

                }else{
                SavedProducts.basketProductsObservable.accept(SavedProducts.basketProductsObservable.value + [self.product])
                }
            }
        }
        }else{
            UIAlertController.show("Sorry", message: "This product is not in stock", from: self)
        }
    }

    @IBAction func addToWishListAction(_ sender: Any) {
        Haptic.feedBack()

        let savedArray = SavedProducts.wishlistProductsObservable.value

        //We ensure here that the user hasn't already added the item to their wishlist
        if !savedArray.contains(product){

            //If they haven't already added the item let's add it.
            SavedProducts.wishlistProductsObservable.accept(savedArray + [product])
            AnimateMe.animateLabel(addedToWishlistLabel)
        }else{
            UIAlertController.show("Wishlist", message: "This item is already in your wishlist.", from: self)
        }
    }
}
