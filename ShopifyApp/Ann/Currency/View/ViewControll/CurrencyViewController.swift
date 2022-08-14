//
//  CurrencyViewController.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 13/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    
    let currencyViewModel = CurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyTableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
        
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        
        currencyViewModel.fetchData()
        
        print(HelperConstant.getseDefaultCurrency())
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.currencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = currencyTableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as? CurrencyTableViewCell else { return UITableViewCell() }
        
        let item = currencyViewModel.currencyData[indexPath.row]
        
        cell.currencyLabelOutlet.text = item.currency ?? ""
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currencyTableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
            
        case 0:
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Done", message: "This currency (EG) set Successfully", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    HelperConstant.saveSetDefaultCurrency(SetDefaultCurrency: "EG")
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        case 1:
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Done", message: "This currency (USD) set Successfully", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    HelperConstant.saveSetDefaultCurrency(SetDefaultCurrency: "USD")
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        default:
            break
            
        }
    }
    
}
