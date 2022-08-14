//
//  SettingViewController.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 05/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    let settingViewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        settingViewModel.fetchData()
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingViewModel.settingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        let item = settingViewModel.settingData[indexPath.row]
        
        cell.imageNameOutlet.tintColor = .systemIndigo
        cell.imageNameOutlet.image = UIImage(systemName: item.imageName ?? "")
        cell.titleLabelOutlet.text = item.title ?? ""
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
            
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
            VC.modalPresentationStyle = .fullScreen
            //VC.totalPrice = self.totalPrice
            self.present(VC, animated: false, completion: nil)
            
        case 1:
            
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
            VC.modalPresentationStyle = .fullScreen
            //VC.totalPrice = self.totalPrice
            self.present(VC, animated: false, completion: nil)
            
        case 2:
            
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "AboutUSViewController") as! AboutUSViewController
            VC.modalPresentationStyle = .fullScreen
            //VC.totalPrice = self.totalPrice
            self.present(VC, animated: false, completion: nil)
            
        case 3:
            
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
            VC.modalPresentationStyle = .fullScreen
            //VC.totalPrice = self.totalPrice
            self.present(VC, animated: false, completion: nil)
            
        case 4:
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    
                    UserDefaultsManager.shared.setUserStatus(userIsLogged: false)
                    
                    UserDefaults.standard.removeObject(forKey: "User_ID")
                    UserDefaults.standard.set(nil, forKey: "User_ID")
                    
                    UserDefaults.standard.removeObject(forKey: "User_Name")
                    UserDefaults.standard.set(nil, forKey: "User_Name")
                    
                    UserDefaults.standard.removeObject(forKey: "User_Email")
                    UserDefaults.standard.set(nil, forKey: "User_Email")
                    
                    UserDefaults.standard.removeObject(forKey: "Password")
                    UserDefaults.standard.set(nil, forKey: "Password")
                    
                    let viewController = UIStoryboard(name: Storyboards.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.login.rawValue) as! LoginViewController
                    viewController.loginStatus = .hideBack
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(alertAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            print("logout")
            
        default:
            break
            
        }
    }
    
}

