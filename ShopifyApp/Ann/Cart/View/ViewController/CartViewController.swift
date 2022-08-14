//
//  CartViewController.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 05/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//
//let viewController = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewController")
import UIKit
import CoreData

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var emptyViewOutlet: UIView!
    
    var totalPrice: Double?
    
    var tottalPrice = 0.0
    var toTalPrice = 0.0
    
    var productInfoViewModel: ProductInfoViewModel?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var product: [CartItemModel]? {
        didSet{
            cartTableView.reloadData()
            
            if product?.isEmpty == true {
                print("product is empty")
                emptyViewOutlet.isHidden = false
            }else {
                print("product is not empty")
                emptyViewOutlet.isHidden = true
            }
            
        }
    }
    
    var adrress = [AddressesModel]()
    
    // database
    let database = DatabaseHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAndConfigureCartTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // to set data and fetch data from database and set it to offlineData => [OfflineStorage]
        product = database.fetch(CartItemModel.self)
        adrress = database.fetch(AddressesModel.self)
        print(product?.count)
        print(product)
        
        print(adrress.count)
        print(adrress)
        
    }
    
    func setupAndConfigureCartTableView() {
        
        cartTableView.register(UINib(nibName: "CartProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CartProductTableViewCell")
        cartTableView.register(UINib(nibName: "SubTotalTableViewCell", bundle: nil), forCellReuseIdentifier: "SubTotalTableViewCell")
        cartTableView.register(UINib(nibName: "ProceedToCheckoutTableViewCell", bundle: nil), forCellReuseIdentifier: "ProceedToCheckoutTableViewCell")
        
        cartTableView.separatorStyle = .none
        
        let frame = CGRect(x: 0, y: 0, width: cartTableView.frame.size.width, height: 1)
        cartTableView.tableFooterView = UIView(frame: frame)
        cartTableView.tableHeaderView = UIView(frame: frame)
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
    }
    
    func checkIfItemIDExistInCart(itemId: Int,itemms:[CartItemModel]) -> Bool {
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
    
    
//    func calcTotalPrice(completion: @escaping (Double?)-> Void){
//        var totalPrice: Double = 0.0
//        getItemsInCart { orders, error in
//            if error == nil {
//                guard let orders = orders, let customerID = self.customerID  else { return }
//                for item in orders{
//                    if item.userID == customerID {
//                        guard let priceStr = item.itemPrice, let price = Double(priceStr) else { return }
//                        totalPrice += Double(item.itemQuantity) * price
//                    }
//                }
//                Helper.shared.setTotalPrice(totalPrice: totalPrice)
//                completion(totalPrice)
//            }else{
//                completion(nil)
//            }
//        }
//    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? product?.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell", for: indexPath) as? CartProductTableViewCell else { return UITableViewCell() }
            
            let item = product?[indexPath.row]
            
            let url = URL(string: item?.itemImage ?? "")
            cell.productImageOutlet.kf.setImage(with: url)
            cell.countLabelOutlet.text = "\(item?.itemQuantity ?? 1)"
            cell.titleLabelOutlet.text = item?.itemName
            cell.priceLabelOutlet.text = item?.itemPrice
            
            if HelperConstant.getseDefaultCurrency() == "EG" {
                
                cell.priceLabelOutlet.text = "\(item?.itemPrice ?? "")" + "  EG"
                
            }else if HelperConstant.getseDefaultCurrency() == "USD" {
                
                cell.priceLabelOutlet.text = "\(Double((Double((item?.itemPrice ?? "")) ?? 0.0) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
                
            }else {
                
                cell.priceLabelOutlet.text = "\(item?.itemPrice ?? "")" + "  EG"
                
            }
            
            toTalPrice = self.product?.map { Double(Double($0.itemPrice) ?? 0) * Double($0.itemQuantity) }.reduce(0, +) ?? 0.0 //(Double(cell.countLabelOutlet.text ?? "") ?? 0.0)
            print(toTalPrice)
            HelperConstant.saveTotal(access_token: "\(toTalPrice)")
            
            cell.MinusTapped = { [weak self] in
                guard let self = self else { return }
                
                // to calculate time
                let dispatchAfter = DispatchTimeInterval.seconds(Int(0.5))  //0.1
                //To call or execute function after some time(After sec)
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
                    guard let self = self else { return }
                    
                    if  (Int(cell.countLabelOutlet.text ?? "0") ?? 0) != 1 {
                        cell.countLabelOutlet.text = String((Int(cell.countLabelOutlet.text ?? "0") ?? 0) - 1)
                        
                        // call function => send quantity to server
                        
                        let quantity = Double(cell.countLabelOutlet.text ?? "0")
                        
                        let cellTotal = self.cartTableView.cellForRow(at: indexPath) as? SubTotalTableViewCell
                        
                        item?.itemQuantity = Int64(cell.countLabelOutlet.text ?? "") ?? 0
                        self.database.save()
                        
                        print(Double(cell.countLabelOutlet.text ?? "") ?? 0.0)
                        
                        self.tottalPrice = (Double(item?.itemPrice ?? "") ?? 0.0) //* (Double(cell.countLabelOutlet.text ?? "") ?? 0.0) //Double(item?.itemQuantity ?? Int64(0.0) + 1)
                        print(self.tottalPrice)
                        print(self.toTalPrice)
                        
                        let getTotal = Double(HelperConstant.getTotal() ?? "")
                        print(getTotal)
                        
                        let finalTotal = (getTotal ?? 0.0) - self.tottalPrice //(toTalPrice ?? 0.0) +
                        print(finalTotal)
                        
                        // toTalPrice => total price => first // Done
                       
                        HelperConstant.saveTotal(access_token: "\(finalTotal)")
                        print(HelperConstant.getTotal())
                        
                        //cellTotal?.totalPriceValueLabelOutlet.text = HelperConstant.getTotal() //"\(finalTotal)"
                        
                        //self.cartTableView.reloadData()
                        
                        self.cartTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                        
                    }
                    
                }
                
            }
            
            cell.plusTapped = { [weak self] in
                guard let self = self else { return }
                
                // to calculate time
                let dispatchAfter = DispatchTimeInterval.seconds(Int(0.5)) //0.1
                //To call or execute function after some time(After sec)
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
                    guard let self = self else { return }
                    
                    cell.countLabelOutlet.text = String((Int(cell.countLabelOutlet.text ?? "0") ?? 0) + 1)
                    
                    let quantity = Double(cell.countLabelOutlet.text ?? "0")
                    
                    let cellTotal = self.cartTableView.cellForRow(at: indexPath) as? SubTotalTableViewCell
                    
                    item?.itemQuantity = Int64(cell.countLabelOutlet.text ?? "") ?? 0
                    self.database.save()
                    
                    print(Double(cell.countLabelOutlet.text ?? "") ?? 0.0)
                    
                    self.tottalPrice = (Double(item?.itemPrice ?? "") ?? 0.0) //* (Double(cell.countLabelOutlet.text ?? "") ?? 0.0) //Double(item?.itemQuantity ?? Int64(0.0) + 1)
                    print(self.tottalPrice)
                    print(self.toTalPrice)
                    
                    let getTotal = Double(HelperConstant.getTotal() ?? "")
                    print(getTotal)
                    
                    let finalTotal = (getTotal ?? 0.0) + self.tottalPrice
                    print(finalTotal)
                   
                    HelperConstant.saveTotal(access_token: "\(finalTotal)")
                    print(HelperConstant.getTotal())
                    
                    self.cartTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    
                }
            }
            
            return cell
            
        }else if indexPath.section == 1 {
            
            guard let cell = cartTableView.dequeueReusableCell(withIdentifier: "SubTotalTableViewCell", for: indexPath) as? SubTotalTableViewCell else { return UITableViewCell() }
            
            toTalPrice = product?.map { Double(Double($0.itemPrice) ?? 0) * Double($0.itemQuantity) }.reduce(0, +) ?? 0.0
            print(toTalPrice)
            
            print(HelperConstant.getTotal())
            
            totalPrice = Double(HelperConstant.getTotal() ?? "")
            
            if HelperConstant.getseDefaultCurrency() == "EG" {
                
                cell.totalPriceValueLabelOutlet.text = "\(Double((HelperConstant.getTotal() ?? ""))?.rounded(toPlaces: 2) ?? 0.0)" + "  EG"
                
            }else if HelperConstant.getseDefaultCurrency() == "USD" {
                
                cell.totalPriceValueLabelOutlet.text = "\(Double((Double((HelperConstant.getTotal() ?? "")) ?? 0.0) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
                
            }else {
                
                cell.totalPriceValueLabelOutlet.text = "\(Double((HelperConstant.getTotal() ?? ""))?.rounded(toPlaces: 2) ?? 0.0)" + "  EG"
                
            }
            
            return cell
            
        }else if indexPath.section == 2 {
            
            guard let cell = cartTableView.dequeueReusableCell(withIdentifier: "ProceedToCheckoutTableViewCell", for: indexPath) as? ProceedToCheckoutTableViewCell else { return UITableViewCell() }
            
            cell.PorceedButtonTapped = { [weak self] in
                
                guard let self = self else { return }
                
                if self.adrress.isEmpty == true {
                    let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.totalPrice = self.totalPrice
                    self.present(VC, animated: false, completion: nil)
                }else {
                    let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.totalPrice = self.totalPrice
                    self.present(VC, animated: false, completion: nil)
                }
                
                
                
            }
            
            return cell
            
        }else {
            return UITableViewCell()
        }
        
    }
    
    // to make swipe action in cell to remove product with indexPath.row
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            guard let item = self.product?[indexPath.row] else { return }
            self.cartTableView.beginUpdates()
            self.database.delete(object: item)
            self.product?.remove(at: indexPath.row)
            self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
            self.cartTableView.endUpdates()
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }else if indexPath.section == 1 {
            return 50
        }else if indexPath.section == 2 {
            return 80
        }else {
            return 0
        }
    }
    
}
