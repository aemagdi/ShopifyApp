//
//  Alert.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController{
    func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(Action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String, complition:@escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: "Ok", style: .destructive) { _ in
            complition()
        }
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    func showAlertForInterNetConnection() {
        let alert = UIAlertController(title: "Network Error", message: "Please, check your internet connection!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator(indicator: NVActivityIndicatorView?,startIndicator: Bool) {
        guard let indicator = indicator else {return}
        DispatchQueue.main.async {
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(indicator)
            
            NSLayoutConstraint.activate([
                indicator.widthAnchor.constraint(equalToConstant: 40),
                indicator.heightAnchor.constraint(equalToConstant: 40),
                indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
        
        if startIndicator {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    func showToastMessage(message: String, color: UIColor) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-120, y: self.view.frame.height-100, width: 260, height: 30))

            toastLabel.textAlignment = .center
            toastLabel.backgroundColor = color
            toastLabel.textColor = .black
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            toastLabel.text = message
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0.0
            }) { (isCompleted) in
                toastLabel.removeFromSuperview()
            }
        }
    
}
