//
//  ProductInfoViewController.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/4/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
import NVActivityIndicatorView

class ProductInfoViewController: UIViewController {

    @IBOutlet weak var bar: UINavigationBar!
    @IBOutlet weak var productImageCollectionView: UICollectionView! {
        didSet {
            productImageCollectionView.delegate = self
            productImageCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var productId: Int?
    var product: Product?
    var isFavourite: Bool?
    var isAddedToCart: Bool?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageControlIndex = 0
    var productInfoViewModel: ProductInfoViewModel?
    let indicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .label, padding: 0)
    
    let database = DatabaseHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
        
        guard Connectivity.shared.isConnectedToInternet() else {
            self.showAlertForInterNetConnection()
            return
        }
        
        self.showActivityIndicator(indicator: self.indicator, startIndicator: true)
        
        let group = DispatchGroup()
        
        productInfoViewModel = ProductInfoViewModel()
        productInfoViewModel?.getProduct(endPoint: "products/\(productId ?? 7730623709398).json")
        productInfoViewModel?.bindingData = { product, error in
            if let product = product {
                self.product = product
                
                group.enter()
                self.isFavourite = self.productInfoViewModel?.getProductsInFavourites(appDelegate: self.appDelegate, product: &(self.product)!, complition: {
                    group.leave()
                })
                
                group.enter()
                self.isAddedToCart = self.productInfoViewModel?.getProductsInShopingCart(appDelegate: self.appDelegate, product: &(self.product)!, complition: {
                    group.leave()
                })
                
                group.notify(queue: .main) {
                    self.setupView()
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                }
            }
                
            if let error = error {
                print(error.localizedDescription)
                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            }
        }
    }
    
    func registerNibFile() {
        productImageCollectionView.register(UINib(nibName: NibFiles.productInfoCell.rawValue , bundle: nil), forCellWithReuseIdentifier: IdentifierCell.productInfoCell.rawValue)
    }
    
    func checkIsFavourite() {
        if isFavourite! {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func checkIsInShoppingCart() {
        if isAddedToCart! {
            addToCartButton.setTitle("REMOVE FROM CART", for: .normal)
        } else {
            addToCartButton.setTitle("ADD TO CART", for: .normal)
        }
    }
    
    func setupView() {
        self.bar.topItem?.title = product?.vendor
        self.productImageCollectionView.reloadData()
        self.pageControl.numberOfPages = product?.images.count ?? 0
        self.productTitle.text = product?.title
        self.productPrice.text = "\(product?.varients?[0].price ?? "0") EGP"
        
        if HelperConstant.getseDefaultCurrency() == "EG" {
            
            productPrice.text = "\(product?.varients?[0].price ?? "")" + "  EG"
            
        }else if HelperConstant.getseDefaultCurrency() == "USD" {
            
            productPrice.text = "\(Double((Double((product?.varients?[0].price ?? "")) ?? 0.0) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
            
        }else {
            
            productPrice.text = "\(product?.varients?[0].price ?? "")" + "  EG"
            
        }
        
        self.productDescription.text = product?.description
        self.addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 2
        self.cosmosView.rating = 3
        checkIsFavourite()
        //checkIsInShoppingCart()
    }
    
    func showAlertNavigateLoginScreen(title: String, message: String) {
            self.showAlert(title: title, message: message) {
                let vc = UIStoryboard(name: Storyboards.login.rawValue, bundle:nil).instantiateViewController(withIdentifier: StoryboardID.login.rawValue) as! LoginViewController
                vc.loginStatus = .showBack
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkIfItemExistInCart(itemId: Int,itemms:[CartItemModel]) -> Bool {
            var check : Bool = false
            for i in itemms {
                if i.itemID == itemId {
                    check = true
                }else {
                    check = false
                }
            }
            return check
        }
    
    @IBAction func onAddToCartPressed(_ sender: Any) {
        
//        if !UserDefaultsManager.shared.getUserStatus() {
//            showAlertNavigateLoginScreen(title: "Alert", message: "you must login to be able to add items to your Cart.")
//            return
//        }
        
        let products = database.fetch(CartItemModel.self)
        if checkIfItemExistInCart(itemId: product?.id ?? 0, itemms: products) {
            print("cant add this product!!")
            let alert = UIAlertController(title: "Warrning", message: "This product already existed in cart", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            
        }else {
            
            guard let cartData = database.add(CartItemModel.self) else { return }
            
            // to make data variables equal myData variables
            cartData.itemID = Int64(product?.id ?? 0)
            cartData.itemImage = product?.image.src ?? ""
            cartData.itemName = product?.title ?? ""
            cartData.itemPrice = product?.varients?[0].price ?? ""
            cartData.itemQuantity = Int64(1)
            cartData.userID = Int64(product?.userID ?? 0)
            
            // to save data to database => coreData => OfflineStorage model
            database.save()
            
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            //VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: false, completion: nil)
        }
        
        // check with mina
//        if !UserDefaultsManager.shared.getUserStatus() {
//            self.showAlertError(title: "Alert", message: "you must login")
//            return
//        }
//
        ////////////////////////////////////////////////////////////////////
//        if isAddedToCart! {
//            addToCartButton.setTitle("ADD TO CART", for: .normal)
//            productInfoViewModel?.removeProductFromCart(appDelegate: appDelegate, product: product!)
//        } else {
//            addToCartButton.setTitle("REMOVE FROM CART", for: .normal)
//            product?.userID = UserDefaultsManager.shared.getUserID()!
//            productInfoViewModel?.addProductToCart(appDelegate: appDelegate, product: product!)
//        }
//        isAddedToCart = !isAddedToCart!
    }
    
    @IBAction func onFavouritePressed(_ sender: Any) {
        if !UserDefaultsManager.shared.getUserStatus() {
            showAlertNavigateLoginScreen(title: "Alert", message: "you must login to be able to add items to your Cart.")
            return
        }
        
        if isFavourite! {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            productInfoViewModel?.removeProductFromFavourites(appDelegate: appDelegate, product: product!)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            product?.userID = UserDefaultsManager.shared.getUserID()!
            productInfoViewModel?.addProductToFavourites(appDelegate: appDelegate, product: product!)
        }
        isFavourite = !isFavourite!
    }
    
    
    @IBAction func onReviewsButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: Storyboards.reviews.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.reviews.rawValue) as! ReviewsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProductInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierCell.productInfoCell.rawValue, for: indexPath) as! ProductInfoCollectionViewCell
        let url = URL(string: product?.images[indexPath.item].src ?? "")
        cell.productImage.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControlIndex = Int(scrollView.contentOffset.x / productImageCollectionView.frame.width)
        pageControl.currentPage = pageControlIndex
    }
}
