//
//  miniFavoriteCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 14/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    var isFavourite: Bool?
    var product: Product?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productsView: FavouriteActionProductScreen?
    var favouritesView: FavoriteActionFavoritesScreen?
    var isInFavouriteScreen: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(product: Product, isFavourite: Bool, isInFavouriteScreen: Bool = false) {
        let imgLink = (product.image.src)
        let url = URL(string: imgLink)
        productImage.kf.setImage(with: url)
        productPrice.text = product.varients?[0].price
        if isFavourite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.product = product
        self.isFavourite = isFavourite
        self.isInFavouriteScreen = isInFavouriteScreen
    }
    
    @IBAction func favoriteProduct(_ sender: Any) {
        if isInFavouriteScreen! {
            actionTakenInCellInFavouritesView()
        } else {
            actionTakenInCellInProductsView()
        }
    }
    
    func actionTakenInCellInProductsView() {
        if !UserDefaultsManager.shared.getUserStatus() {
            productsView?.showAlert(title: "Alert",message: "You must login")
            return
        }
        
        if isFavourite! {
            productsView?.deleteFavourite(appDelegate: appDelegate, product: product!)
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            product?.userID = UserDefaultsManager.shared.getUserID()!
            productsView?.addFavourite(appDelegate: appDelegate, product: product!)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        isFavourite = !isFavourite!
    }
    
    func actionTakenInCellInFavouritesView() {
        favouritesView?.deleteFavourite(appDelegate: appDelegate, product: product!)
    }
    
}
