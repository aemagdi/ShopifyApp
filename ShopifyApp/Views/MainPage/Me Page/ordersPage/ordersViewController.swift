//
//  OrdersViewController.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 16/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class OrdersViewController: UIViewController {
    
    // MARK: - Variables & Constants
    var ordersArray = [FinalOrder]()
    var ordersViewModel: OrdersViewModel?
    let indicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .label, padding: 0)
    
    
    
    // MARK: - IBActions & IBOutlets
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var ordersLabel: UILabel!
    
    @IBOutlet weak var ordersTable: UITableView!{
        didSet {
            ordersTable.delegate = self
            ordersTable.dataSource = self
        }
    }


    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
        ordersViewModel = OrdersViewModel()
        ordersLabel.text = "Below are your past orders listed:"
    }
    
    // MARK: - View Will Appear

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard Connectivity.shared.isConnectedToInternet() else {
            self.showAlertForInterNetConnection()
            return
        }
        
        self.showActivityIndicator(indicator: self.indicator, startIndicator: true)
        
        ordersViewModel?.bindingData = { orders, error in
            if let orders = orders {
                self.ordersArray = orders
                print("line 58 - Orders Array returned  = \(self.ordersArray.count)")
                DispatchQueue.main.async {
                    self.ordersTable.reloadData()
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                }
            }
            if let error = error {
                print(error.localizedDescription)
                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            }
        }
        ordersViewModel?.fetchOrders(endPoint: "orders.json?customer_id=")
    }
    
    // MARK: - Other functions

    
    func registerNibFile() {
        ordersTable.register(UINib(nibName: "fullOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "fullOrderCellID")
    }
    
}


// MARK: - Table View Functions


extension OrdersViewController: UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullOrderCellID", for: indexPath) as! fullOrderTableViewCell
        
        cell.orderID.text = "Order #\(ordersArray[indexPath.row].id ?? 0)"
        cell.orderCreatedAt.text = "Created at: \(ordersArray[indexPath.row].created_at ?? "Time not set")"
        cell.customerName.text = "Customer's name: \(ordersArray[indexPath.row].customer?.first_name ?? "Name not set")"
        cell.customerEmail.text = "Contact email: \(ordersArray[indexPath.row].customer?.email ?? "Email not set")"
        //cell.orderPrice.text = "Total price: \(ordersArray[indexPath.row].total_line_items_price ?? "p=Price not set")"
        
        if HelperConstant.getseDefaultCurrency() == "EG" {
            
            cell.orderPrice.text = "Price: \(ordersArray[indexPath.row].total_line_items_price ?? "amount not set")" + "  EG"
            
        }else if HelperConstant.getseDefaultCurrency() == "USD" {
            
            cell.orderPrice.text = "Price: \(Double((Double((ordersArray[indexPath.row].total_line_items_price ?? "amount not set")) ?? 0.0) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
            
        }else {
            
            cell.orderPrice.text = "Price: \(ordersArray[indexPath.row].total_line_items_price ?? "amount not set")" + "  EG"
            
        }
        
        return cell
        
    }
    
}

