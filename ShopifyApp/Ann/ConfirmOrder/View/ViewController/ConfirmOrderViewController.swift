//
//  ConfirmOrderViewController.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 06/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {
    
    @IBOutlet weak var subTotalLabelOutlet: UILabel!
    @IBOutlet weak var subTotalValueLabelOutlet: UILabel!
    
    @IBOutlet weak var shoppingFeeLabelOutlet: UILabel!
    @IBOutlet weak var shoppingFeeValueLabelOutlet: UILabel!
    
    @IBOutlet weak var couponTFOutlet: UITextField!
    @IBOutlet weak var couponStatusLabel: UILabel!
    
    @IBOutlet weak var discountLabelOutlet: UILabel!
    @IBOutlet weak var discountValueLabelOutlet: UILabel!
    
    @IBOutlet weak var priceLabelOutlet: UILabel!
    
    @IBOutlet weak var placeOrderButtonOutlet: UIButton!
    
    var totalPrice: Double?
    var finalTotalPrice: Double?
    var finalTotalPriceString: String?
    
    var order : OrderItem?
    let customerID = 1 //Helper.shared.getUserID()
    var orderProduct : [OrderItem] = []
    var totalOrder = Order()
    
    var product = [CartItemModel]()
    
    var network = SubmitOrderNetworking.shared
    
    // database
    let database = DatabaseHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIValues()
        
    }
    
    func setupUIValues() {
        
        product = database.fetch(CartItemModel.self)
        finalTotalPrice = totalPrice
        subTotalValueLabelOutlet.text = "\(totalPrice ?? 0.0) EG"
        
        if HelperConstant.getseDefaultCurrency() == "EG" {
            
            finalTotalPriceString = "\(Double(totalPrice ?? 0.0))" + "  EG"
            subTotalValueLabelOutlet.text = finalTotalPriceString
            priceLabelOutlet.text = "  EGP  \(totalPrice ?? 0.0)"
            
        }else if HelperConstant.getseDefaultCurrency() == "USD" {
            
            finalTotalPriceString = "\(Double((Double(totalPrice ?? 0.0)) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
            subTotalValueLabelOutlet.text = finalTotalPriceString
            priceLabelOutlet.text = "  USD  " + "\(Double((Double(totalPrice ?? 0.0)) / Double(18.87)).rounded(toPlaces: 2))"
            
        }else {
            
            finalTotalPriceString = "\(Double(finalTotalPrice ?? 0.0))" + "  EG"
            
        }
        
        shoppingFeeValueLabelOutlet.text = "0.0"
        discountValueLabelOutlet.text = "0 %"
        couponStatusLabel.text = "no coupon exist"
        
    }
    
    func getCurrentData() -> String {
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        
        return dateString
        
    }
    
    func showAlertNavigateLoginScreen(title: String, message: String) {
        self.showAlert(title: title, message: message) {
            let vc = UIStoryboard(name: Storyboards.login.rawValue, bundle:nil).instantiateViewController(withIdentifier: StoryboardID.login.rawValue) as! LoginViewController
            vc.loginStatus = .showBack
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func placeOrderButtonAction(_ sender: Any) {
        
        if !UserDefaultsManager.shared.getUserStatus() {
            showAlertNavigateLoginScreen(title: "Alert", message: "you must login to be able to add items to your Cart.")
            return
        }else {
            postOrder(cartArray: product)
        }
        
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        
        if couponTFOutlet.text == "free_10" {
            
            discountValueLabelOutlet.text = "10 %"
            
            if HelperConstant.getseDefaultCurrency() == "EG" {
                
                priceLabelOutlet.text = "  EGP  " + "\((totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 10) / 100))"
                finalTotalPrice = (totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 10) / 100)
                finalTotalPriceString = "\(Double(totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 10) / 100))" + "  EG"
                
            }else if HelperConstant.getseDefaultCurrency() == "USD" {
                
                priceLabelOutlet.text = "  USD  " + "\(Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(10.0)) / Double(100.0))) / Double(18.87)).rounded(toPlaces: 2))"
                finalTotalPrice = Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(10.0)) / Double(100.0))) / Double(18.87)).rounded(toPlaces: 2)
                finalTotalPriceString = "\(Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(10.0)) / Double(100.0))) / Double(18.87)))" + "  USD"
                
            }else {
                
                finalTotalPriceString = "\(Double(finalTotalPrice ?? 0.0))" + "  EG"
                
            }
            
            couponStatusLabel.text = "valid coupon"
            couponStatusLabel.textColor = .green
            
        }else if couponTFOutlet.text == "free_15" {
            
            discountValueLabelOutlet.text = "15 %"
            
            if HelperConstant.getseDefaultCurrency() == "EG" {
                
                priceLabelOutlet.text = "  EGP  " + "\((totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 15) / 100))"
                finalTotalPrice = (totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 15) / 100)
                finalTotalPriceString = "\((totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 15) / 100))" + "  EG"
                
            }else if HelperConstant.getseDefaultCurrency() == "USD" {
                
                priceLabelOutlet.text = "  USD  " + "\(Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(15.0)) / Double(100.0))) / Double(18.87)).rounded(toPlaces: 2))"
                finalTotalPrice = Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(15.0)) / Double(100.0))) / Double(18.87)).rounded(toPlaces: 2)
                finalTotalPriceString = "\(Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(15.0)) / Double(100.0))) / Double(18.87)))" + "  USD"
                
            }else {
                
                finalTotalPriceString = "\(Double(finalTotalPrice ?? 0.0))" + "  EG"
                
            }
            
            couponStatusLabel.text = "valid coupon"
            couponStatusLabel.textColor = .green
            
        }else if couponTFOutlet.text == "free_20" {
            
            discountValueLabelOutlet.text = "20 %"
            
            if HelperConstant.getseDefaultCurrency() == "EG" {
                
                priceLabelOutlet.text = "  EGP  " + "\((totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 20) / 100))"
                finalTotalPrice = (totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 20) / 100)
                finalTotalPriceString = "\((totalPrice ?? 0.0) - (((totalPrice ?? 0.0) * 20) / 100))" + "  EG"
                
            }else if HelperConstant.getseDefaultCurrency() == "USD" {
                
                priceLabelOutlet.text = "  USD  " + "\(Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(20.0)) / Double(100.0))) / Double(18.87)).rounded(toPlaces: 2))"
                finalTotalPrice = Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(20.0)) / Double(100.0))) / Double(18.87)).rounded(toPlaces: 2)
                finalTotalPriceString = "\(Double(Double(Double(totalPrice ?? 0.0) - Double(Double(Double(totalPrice ?? 0.0) * Double(20.0)) / Double(100.0))) / Double(18.87)))" + "  USD"
                
            }else {
                
                finalTotalPriceString = "\(Double(finalTotalPrice ?? 0.0))" + "  EG"
                
            }
            
            couponStatusLabel.text = "valid coupon"
            couponStatusLabel.textColor = .green
            
        }else {
            
            discountValueLabelOutlet.text = "0 %"
            
            if HelperConstant.getseDefaultCurrency() == "EG" {
                
                finalTotalPriceString = "\(Double((Double(totalPrice ?? 0.0))).rounded(toPlaces: 2))" + "  EG"
                priceLabelOutlet.text = "  EG  " + "\(Double((Double(totalPrice ?? 0.0))).rounded(toPlaces: 2))"
                
            }else if HelperConstant.getseDefaultCurrency() == "USD" {
                
                finalTotalPriceString = "\(Double((Double(totalPrice ?? 0.0)) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
                priceLabelOutlet.text = "  USD  " + "\(Double((Double(totalPrice ?? 0.0)) / Double(18.87)).rounded(toPlaces: 2))"
                
            }else {
                
                finalTotalPriceString = "\(Double(finalTotalPrice ?? 0.0))" + "  EG"
                
            }
            
            //couponStatusLabel.text = "invalid coupon"
            couponStatusLabel.text = "no coupon exist"
            couponStatusLabel.textColor = .darkGray
            
        }
        
    }
    
}

extension ConfirmOrderViewController {
    
    func postOrder(cartArray:[CartItemModel]){
        if cartArray.count == 0 {
            //self.showEmptyCartAlert()
        }
        else{
            for item in cartArray {
                orderProduct.append(OrderItem(variant_id: Int(item.itemID), quantity: Int(item.itemQuantity), name: item.itemName, price: item.itemPrice,title:item.itemName))
            }
            
            // missing param
            
            let order = Order( customer: Customer(first_name: UserDefaultsManager.shared.getUserName(), email: UserDefaultsManager.shared.getUserEmail(), tags: HelperConstant.getPassword(), id: UserDefaultsManager.shared.getUserID(), addresses: [Address(id: Int(HelperConstant.getAddressID() ?? "1"), customer_id: UserDefaultsManager.shared.getUserID(), address1: HelperConstant.getAddressTitle(), city: HelperConstant.getCity(), country: HelperConstant.getcountry(), phone: HelperConstant.getAddressPhone())]), line_items: self.orderProduct, created_at: getCurrentData(), current_total_price: finalTotalPriceString) //Order(customer: Customer(, line_items: self.orderProduct, current_total_price: self.totalPrice) //self.totalOrder.current_total_price
            let ordertoAPI = OrderToAPI(order: order)
            self.network.SubmitOrder(order: ordertoAPI) { data, urlResponse, error in
                if error == nil {
                    print("Post order success")
                    if let data = data{
                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                        let returnedOrder = json["order"] as? Dictionary<String,Any>
                        let returnedCustomer = returnedOrder?["customer"] as? Dictionary<String,Any>
                        let id = returnedCustomer?["id"] as? Int ?? 0
                        print(json)
                        print("----------")
                        print(id)
                        
                        for i in cartArray {
                            self.database.delete(object: i)
                        }
                        self.database.save()
                        UserDefaults.standard.setValue(nil, forKey: "totalPrice")
                        
                    }
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Done", message: "Order submitted successfully!", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            
                            
                            let viewController = UIStoryboard(name:"MainPage", bundle: nil).instantiateViewController(withIdentifier: "TabScreenID")
                            UIApplication.shared.windows.first?.rootViewController = viewController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                            
                        })
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
}
