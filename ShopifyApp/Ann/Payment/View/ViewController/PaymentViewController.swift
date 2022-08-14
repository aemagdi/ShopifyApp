//
//  PaymentViewController.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 05/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import PassKit

enum PayStatus {
    case applePay
    case cash
    case non
}

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var containerOfContinueToPaymentView: UIView!
    
    @IBOutlet weak var applePayButtonOutlet: UIButton!
    @IBOutlet weak var cashOnDeliveryButtonOutlet: UIButton!
    
    var selected: Int?
    
    var totalPrice: Double?
    var finalTotalPrice: String?
    
    var order : OrderItem?
    let customerID = 1 //Helper.shared.getUserID()
    var orderProduct : [OrderItem] = []
    var totalOrder = Order()
    
    var ShippingMethods: [PKShippingMethod] = []
    var ShipingMethods: PKShippingMethod?
    var paymentSummaryItems : [PKPaymentSummaryItem] = []
    var paymentRequest: PKPaymentRequest = PKPaymentRequest()
    
    var payStatus: PayStatus = .non
    
    var network = SubmitOrderNetworking.shared
    
    // database
    let database = DatabaseHandler.shared
    
    var product = [CartItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payStatus = .non
        product = database.fetch(CartItemModel.self)
        
        if HelperConstant.getseDefaultCurrency() == "EG" {
            
            finalTotalPrice = "\(Double(totalPrice ?? 0.0))" + "  EG"
            
        }else if HelperConstant.getseDefaultCurrency() == "USD" {
            
            finalTotalPrice = "\(Double((Double(totalPrice ?? 0.0)) / Double(18.87)).rounded(toPlaces: 2))" + "  USD"
            
        }else {
            
            finalTotalPrice = "\(Double(totalPrice ?? 0.0))" + "  EG"
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerOfContinueToPaymentView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func getCurrentData() -> String {
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        
        return dateString
        
    }
    
    @IBAction func applePayButtonAction(_ sender: Any) {
        
        applePayButtonOutlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        cashOnDeliveryButtonOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
        
        payStatus = .applePay
        
    }
    
    @IBAction func cashOnDeliveryButtonAction(_ sender: Any) {
        
        applePayButtonOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
        cashOnDeliveryButtonOutlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        
        payStatus = .cash
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func continueToPayButtonAction(_ sender: Any) {
        
        switch payStatus {
            
        case .applePay:
            
            if !UserDefaultsManager.shared.getUserStatus() {
                showAlertNavigateLoginScreen(title: "Alert", message: "you must login to be able to add items to your Cart.")
                return
            }else {
                handleApplePay()
            }
            
        case .cash:
            
            let VC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
            VC.totalPrice = totalPrice
            
            self.present(VC, animated: false, completion: nil)
            
        case .non:
            
            let alert = UIAlertController(title: "Warrning", message: "something Went wrrong", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            
        
        
        }
        
    }
    
    func handleApplePay() {
            
            paymentRequest.merchantIdentifier = "Ezzat.ShopifyApp"
            paymentRequest.supportedNetworks = [.visa, .masterCard, .amex, .discover, .mada]
            paymentRequest.supportedCountries = ["US"]
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.countryCode = "US"
            paymentRequest.currencyCode = "USD"
            paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Total Amount", amount: NSDecimalNumber(string: finalTotalPrice), type: .final)]
            
            let total = PKPaymentSummaryItem.init(label: "Total", amount: NSDecimalNumber(string: finalTotalPrice), type: .final)
            let tax   = PKPaymentSummaryItem.init(label: "Tax", amount: NSDecimalNumber(string: "0.15 %"), type: .final)
            let fare = PKPaymentSummaryItem.init(label: "Shopify company", amount: NSDecimalNumber(string: finalTotalPrice), type: .final)
            paymentRequest.paymentSummaryItems = [ total, tax, fare ]
            
            paymentRequest.requiredShippingAddressFields = PKAddressField.all
            
            let twoday = PKShippingMethod(label: "Two Day", amount: NSDecimalNumber(string: "100.0 US"), type: .final)
            
            twoday.detail = "2 Day delivery"
            twoday.identifier = "2day"
            
            let shippingMethods : [PKShippingMethod] = [ twoday ]
            paymentRequest.shippingMethods = shippingMethods
            
            if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                controller.delegate = self
                present(controller, animated: true, completion: nil)
            }
            
        }
    
    func showAlertNavigateLoginScreen(title: String, message: String) {
            self.showAlert(title: title, message: message) {
                let vc = UIStoryboard(name: Storyboards.login.rawValue, bundle:nil).instantiateViewController(withIdentifier: StoryboardID.login.rawValue) as! LoginViewController
                vc.loginStatus = .showBack
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        //completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
        // Perform some very basic validation on the provided contact information
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        
        if payment.shippingContact?.postalAddress?.isoCountryCode != "US" {
            let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only picks up in the United States")

            //payment.token.paymentData.llength == 0

            let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
            errors.append(pickupError)
            errors.append(countryError)
            status = .failure
            print(errors)
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            
            postOrder(cartArray: product)
            
        }
        let paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: paymentStatus, errors: errors))
        
        //print(completion(PKPaymentAuthorizationResult(status: paymentStatus, errors: errors)))
        
    }
 
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
 
}

extension PaymentViewController {
    
    func postOrder(cartArray:[CartItemModel]){
        if cartArray.count == 0 {
            //self.showEmptyCartAlert()
        }
        else{
            for item in cartArray {
                orderProduct.append(OrderItem(variant_id: Int(item.itemID), quantity: Int(item.itemQuantity), name: item.itemName, price: item.itemPrice,title:item.itemName))
            }
            
            // missing param
            let order = Order(customer: Customer(first_name: UserDefaultsManager.shared.getUserName(), email: UserDefaultsManager.shared.getUserEmail(), tags:  HelperConstant.getPassword(), id: UserDefaultsManager.shared.getUserID(), addresses: [Address(id: Int(HelperConstant.getAddressID() ?? "1"), customer_id: UserDefaultsManager.shared.getUserID(), address1: HelperConstant.getAddressTitle(), city: HelperConstant.getCity(), country: HelperConstant.getcountry(), phone: HelperConstant.getAddressPhone())]), line_items: self.orderProduct, created_at: getCurrentData(), current_total_price: finalTotalPrice) //Order(customer: Customer(, line_items: self.orderProduct, current_total_price: self.totalPrice) //self.totalOrder.current_total_price
//        contactEmail: UserDefaultsManager.shared.getUserEmail(), totalLineItemsPrice: finalTotalPrice, totalPriceUsd: finalTotalPrice
            
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
                        let alert = UIAlertController(title: "Done", message: "Order submitted Successfully", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            
                            
                            let viewController = UIStoryboard(name:"MainPage", bundle: nil).instantiateViewController(withIdentifier: "MainPageID")
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

