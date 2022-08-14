//
//  AddressListViewController.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 10/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class AddressListViewController: UIViewController {
    
    @IBOutlet weak var AddressesListTableView: UITableView!
    
    var totalPrice: Double?
    
    var adrress: [AddressesModel]? {
        didSet{
            AddressesListTableView.reloadData()
        }
    }
    
    var addressId: Int?
    
    // database
    let database = DatabaseHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAndConfigureCartTableView()
        addressId = HelperConstant.getsetDefaultAddresID()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // to set data and fetch data from database and set it to offlineData => [OfflineStorage]
        adrress = database.fetch(AddressesModel.self)
        print(adrress?.count)
        print(adrress)
        
    }
    
    func setupAndConfigureCartTableView() {
        
        AddressesListTableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        
        AddressesListTableView.separatorStyle = .none
        
        let frame = CGRect(x: 0, y: 0, width: AddressesListTableView.frame.size.width, height: 1)
        AddressesListTableView.tableFooterView = UIView(frame: frame)
        AddressesListTableView.tableHeaderView = UIView(frame: frame)
        
        AddressesListTableView.contentInset.top = 40
        
        AddressesListTableView.delegate = self
        AddressesListTableView.dataSource = self
        
    }
    
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adrress?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = AddressesListTableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell", for: indexPath) as? AddressListTableViewCell else { return UITableViewCell() }
        
        let item = adrress?[indexPath.row]
        print(item?.addressId)
        cell.countryLabelOutlet.text = item?.countryName ?? ""
        cell.cityLabelOutlet.text = item?.cityName ?? ""
        cell.addressLabelOutlet.text = item?.addressName ?? ""
        
        if item?.addressId ?? 0 == addressId ?? 0 {
            
            // change view color
            cell.containerView.backgroundColor = .systemIndigo
            
        }else {
            cell.containerView.backgroundColor = .systemBackground
        }
        
        return cell
        
    }
    
    // to make swipe action in cell to remove product with indexPath.row
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            guard let item = self.adrress?[indexPath.row] else { return }
            self.AddressesListTableView.beginUpdates()
            self.database.delete(object: item)
            self.adrress?.remove(at: indexPath.row)
            self.AddressesListTableView.deleteRows(at: [indexPath], with: .automatic)
            self.AddressesListTableView.endUpdates()
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = adrress?[indexPath.row]
        
        HelperConstant.setDefaultAddresID(SetDefaultAddresID: Int(item?.addressId ?? 0))
        addressId = HelperConstant.getsetDefaultAddresID()
        
        HelperConstant.saveAddressID(addressID: "\(item?.addressId ?? 0)")
        HelperConstant.saveCountry(country: item?.countryName ?? "")
        HelperConstant.saveCity(City: item?.cityName ?? "")
        HelperConstant.saveAddressTitle(AddressTitle: item?.addressName ?? "")
        HelperConstant.saveAddressPhone(AddressPhone: "\(item?.phoneNumber ?? 0)")
        
        AddressesListTableView.reloadData()
        
    }
    
}
