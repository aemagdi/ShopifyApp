//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 12/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MeViewController: UIViewController{
    var favoritesArray = [Product]()
    var ordersArray = [FinalOrder]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favoritesViewModel: FavoritesViewModel?
    var ordersViewModel: OrdersViewModel?
    let indicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .label, padding: 0)
    
    
    
    // MARK: - Navigation section
    
    @IBAction func shoppingCart(_ sender: Any) {
//        if UserDefaultsManager.shared.getUserStatus(){
//            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//            //VC.modalPresentationStyle = .fullScreen
//            self.present(VC, animated: false, completion: nil)
//
//        }
//            else {
//                showWarning()
//            }
        
        let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        //VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: false, completion: nil)
        
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        if UserDefaultsManager.shared.getUserStatus(){
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: false, completion: nil)        }
            else {
                showWarning()
            }
        
    }
    
    
    @IBOutlet weak var welcomeName: UILabel!

    // MARK: - Orders section
    @IBOutlet weak var orderSectionButtons: UIStackView!
    @IBAction func ordersMore(_ sender: Any) {
        let VC = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "ordersPageID") as! OrdersViewController
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: false, completion: nil)
        
    }
    
    @IBOutlet weak var ordersSection: UIStackView!
    @IBOutlet weak var ordersTableView: UITableView!{
        didSet {
            ordersTableView.delegate = self
            ordersTableView.dataSource = self
        }
    }
    
    
    // MARK: - Wishlist section
    
    @IBOutlet weak var wishlistSectionButtons: UIStackView!
    
    @IBAction func wishlistMore(_ sender: Any) {
            let vc = UIStoryboard(name: Storyboards.favourites.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.favourites.rawValue) as! FavoritesViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var wishlistSection: UICollectionView!
    @IBOutlet weak var favouritesCV: UICollectionView!{
        didSet {
            favouritesCV.delegate = self
            favouritesCV.dataSource = self
        }
    }
    
    // MARK: - Login/Register section

    @IBOutlet weak var loginRegisterSection: UIStackView!

    @IBAction func loginButton(_ sender: Any) {
        let vc = UIStoryboard(name: Storyboards.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.login.rawValue) as! LoginViewController
        vc.loginStatus = .showBack
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let vc = UIStoryboard(name: Storyboards.register.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.register.rawValue) as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
        favoritesViewModel = FavoritesViewModel()
        ordersViewModel = OrdersViewModel()

    }
    
    // MARK: - View Will Appear

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard Connectivity.shared.isConnectedToInternet() else {
            self.showAlertForInterNetConnection()
            return
        }
        
        self.showActivityIndicator(indicator: self.indicator, startIndicator: true)

        favoritesViewModel?.bindingData = { favourites, error in
            if let favourites = favourites {
                self.favoritesArray = favourites
                DispatchQueue.main.async {
                    self.favouritesCV.reloadData()
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                    self.handleWishlistSection()
                }
            }
            
            if let error = error {
                print(error.localizedDescription)
                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            }
        }

        favoritesViewModel?.fetchfavorites(appDelegate: appDelegate, userId: UserDefaultsManager.shared.getUserID() ?? 1)
        
        ordersViewModel?.bindingData = { orders, error in
            if let orders = orders {
                self.ordersArray = orders
                print("line 139 - Orders Array returned  = \(self.ordersArray.count)")
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                    self.handleOrderSection()
                }
            }
            
            if let error = error {
                print(error.localizedDescription)
                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            }
        }
        
        ordersViewModel?.fetchOrders(endPoint: "orders.json?customer_id=")
        whenUserLoggedIn()
    }
    
    // MARK: - Other functions

    
    func registerNibFile() {
        favouritesCV.register(UINib(nibName: "MiniProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MiniProductCellID")
        ordersTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "ordersCellID")
        
    }
    
    func whenUserLoggedIn(){
        if UserDefaultsManager.shared.getUserStatus() {
            welcomeName.text = "Welcome, " + UserDefaultsManager.shared.getUserName()!
            sectionsAreHidden(state: false)
        }
        else{
            welcomeName.text = "Please log in to view your data!"
            welcomeName.textColor = UIColor.black
            sectionsAreHidden(state: true)
        }
    }
    
    func sectionsAreHidden(state: Bool){
        orderSectionButtons.isHidden = state
        ordersSection.isHidden = state
        wishlistSection.isHidden = state
        wishlistSectionButtons.isHidden = state
        loginRegisterSection.isHidden = !state
    }
    
    func handleOrderSection(){
        if ordersArray.isEmpty{
        ordersSection.isHidden = true
        }
        else{
            ordersSection.isHidden = false
        }
    }
    func handleWishlistSection(){
        if favoritesArray.isEmpty{
            wishlistSection.isHidden = true
            }
        else{
            wishlistSection.isHidden = false
        }
    }
    
    func showWarning(){
        self.showAlert(title: "Alert", message: "You must log in to access this page!") {
            self.loginButton(self)
        }
    }

    }
// MARK: - Collection View Functions

extension MeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesArray.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniProductCellID", for: indexPath) as! MiniProductCollectionViewCell
            cell.favouritesView = self
            cell.configureCell(product: favoritesArray[indexPath.row], isFavourite: true, isInFavouriteScreen: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfoVC = UIStoryboard(name: Storyboards.productInfo.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.productInfo.rawValue) as! ProductInfoViewController
        productInfoVC.productId = favoritesArray[indexPath.row].id
        productInfoVC.modalPresentationStyle = .fullScreen
        self.present(productInfoVC, animated: true, completion: nil)
    }
}

// MARK: - Table View Functions


extension MeViewController: UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCellID", for: indexPath) as! OrdersTableViewCell
        cell.orderCreatedAt.text = "Created at: \(ordersArray[indexPath.row].created_at ?? "time not set")"
        //cell.ordersPrice.text = "Price: \(ordersArray[indexPath.row].total_line_items_price ?? "amount not set")"
        
        if HelperConstant.getseDefaultCurrency() == "EG" {
            
            cell.ordersPrice.text = "Price: \(ordersArray[indexPath.row].total_line_items_price ?? "amount not set")" + "  EG"
            
        }else if HelperConstant.getseDefaultCurrency() == "USD" {
            
            cell.ordersPrice.text = "Price: \(Double((Double((ordersArray[indexPath.row].total_line_items_price ?? "amount not set")) ?? 0.0) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
            
        }else {
            
            cell.ordersPrice.text = "Price: \(ordersArray[indexPath.row].total_line_items_price ?? "amount not set")" + "  EG"
            
        }
            
        
        return cell    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension MeViewController: FavoriteActionFavoritesScreen {
    func deleteFavourite(appDelegate: AppDelegate, product: Product) {
        favoritesViewModel?.deleteFavourite(appDelegate: appDelegate, product: product)
        favoritesArray = favoritesArray.filter { $0.id != product.id }
        favouritesCV.reloadData()
    } }


