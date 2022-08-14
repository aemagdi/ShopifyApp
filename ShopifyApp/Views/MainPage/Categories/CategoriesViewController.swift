//
//  CategoriesViewController.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 10/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JJFloatingActionButton

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var selectedButton = true
    var productsArray = [Product]()
    var categoriesViewModel: CategoriesViewModel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let indicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .label, padding: 0)

    var actionButton = JJFloatingActionButton()
    @IBOutlet weak var productsCV: UICollectionView!{
        didSet {
            productsCV.delegate = self
            productsCV.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
        createFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard Connectivity.shared.isConnectedToInternet() else {
            self.showAlertForInterNetConnection()
            return
        }
        
        self.showActivityIndicator(indicator: self.indicator, startIndicator: true)
        
        categoriesViewModel = CategoriesViewModel()
        categoriesViewModel?.fetchProducts(endPoint: "products.json")
        categoriesViewModel?.bindingData = { products, error in
            if let products = products{
                self.productsArray = products
                DispatchQueue.main.async {
                    self.productsCV.reloadData()
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                }
            }
          
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerNibFile() {
        productsCV.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCellID")
    }
    
    @IBAction func cartButtonAction(_ sender: Any) {
        
        let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        //VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: false, completion: nil)
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCV.dequeueReusableCell(withReuseIdentifier: "ProductCellID", for: indexPath) as! ProductCollectionViewCell
        cell.productsView = self
        let isFavorite = categoriesViewModel!.getProductsInFavourites(appDelegate: appDelegate, product: &productsArray[indexPath.row])
        cell.configureCell(product: productsArray[indexPath.row], isFavourite: isFavorite)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfoVC = UIStoryboard(name: "ProductInfo", bundle: nil).instantiateViewController(withIdentifier: "MProductInfoVC") as! ProductInfoViewController
        productInfoVC.productId = productsArray[indexPath.row].id
        productInfoVC.modalPresentationStyle = .fullScreen
        self.present(productInfoVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var categoriesSegments: UISegmentedControl!
    
    @IBAction func categories(_ sender: UISegmentedControl) {
        switch categoriesSegments.selectedSegmentIndex{
                case 0:
                categoriesViewModel?.selectedMenCategory()
                case 1:
                categoriesViewModel?.selectedWomenCategory()
                case 2:
                categoriesViewModel?.selectedKidsCategory()
                case 3:
                categoriesViewModel?.selectedSaleCategory()
                default:
                    break
        }
    }
    
    
    @IBAction func onFavoriteButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: Storyboards.favourites.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.favourites.rawValue) as! FavoritesViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
   
}
   
extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        categoriesViewModel?.search(searchInput: searchText)
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 2, height: 160)
    }
}

extension CategoriesViewController: FavouriteActionProductScreen {
    func addFavourite(appDelegate: AppDelegate, product: Product) {
        categoriesViewModel?.addFavourite(appDelegate: appDelegate, product: product)
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Product) {
        categoriesViewModel?.deleteFavourite(appDelegate: appDelegate, product: product)
    }
    
    func showAlertNavigateLoginScreen() {
            self.showAlert(title: "Alert", message: "you must login to be able to add items to your favourites.") {
                let vc = UIStoryboard(name: Storyboards.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.login.rawValue) as! LoginViewController
                vc.loginStatus = .showBack
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
}

extension CategoriesViewController {
    func createFloatingButton() {
        actionButton.addItem(title: "", image: UIImage(named: "sneakers")?.withRenderingMode(.alwaysOriginal)) { item in
            self.categoriesViewModel?.selectedShoesCategory()
            self.actionButton.buttonImage = UIImage(named: "sneakers")
        }

        actionButton.addItem(title: "", image: UIImage(named: "shirt")?.withRenderingMode(.alwaysOriginal)) { item in
            self.categoriesViewModel?.selectedShirtsCategory()
            self.actionButton.buttonImage = UIImage(named: "shirt")
        }
        
        actionButton.addItem(title: "", image: UIImage(named: "wedding-rings")?.withRenderingMode(.alwaysOriginal)) { item in
            self.categoriesViewModel?.selectedAccessoriesCategory()
            self.actionButton.buttonImage = UIImage(named: "wedding-rings")
        }

        actionButton.display(inViewController: self)
        floatingConfigration()
    }
    
    func floatingConfigration() {
        actionButton.handleSingleActionDirectly = false
        actionButton.buttonDiameter = 50
        actionButton.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        actionButton.buttonImage = UIImage(named: "sneakers")
        actionButton.buttonColor = .purple
        actionButton.buttonImageColor = .white
        actionButton.buttonImageSize = CGSize(width: 20, height: 20)

        actionButton.buttonAnimationConfiguration = .transition(toImage: UIImage(named: "cancel")!)
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 14)

        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.4)
        actionButton.layer.shadowRadius = CGFloat(2)

        actionButton.itemSizeRatio = CGFloat(0.75)
        actionButton.configureDefaultItem { item in
            item.titlePosition = .trailing

            item.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
            item.titleLabel.textColor = .white
            item.buttonColor = .white
            item.imageSize = CGSize(width: 15, height: 15)
            item.buttonImageColor = .black

            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }
    }
}
