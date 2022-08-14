//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

enum LoginStatus {
    case hideBack
    case showBack
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var loginStatus: LoginStatus = .showBack
    
    var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loginViewModel = LoginViewModel(networkManager: NetworkManager())
        
//        switch loginStatus {
//        case .hideBack:
//            backButton.isHidden = true
//        case .showBack:
//            backButton.isHidden = false
//        }
        
    }
    
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        login()
    }
    
    @IBAction func onRegisterButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: Storyboards.register.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.register.rawValue) as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupView() {
        email.layer.cornerRadius = 15
        email.layer.borderWidth = 2
        password.layer.cornerRadius = 15
        password.layer.borderWidth = 2
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
//        skipButton.layer.cornerRadius = registerButton.frame.height / 2
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIBarButtonItem) {
        print("back button working")
        let mainPageVC = UIStoryboard(name: Storyboards.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.tabScreen.rawValue) as! mainTabBarControllerViewController
            mainPageVC.modalPresentationStyle = .fullScreen
            self.present(mainPageVC, animated: true, completion: nil)
    }
    
//    @IBAction func skipButtonAction(_ sender: Any) {
//        let mainPageVC = UIStoryboard(name: Storyboards.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.tabScreen.rawValue) as! mainTabBarControllerViewController
//        mainPageVC.modalPresentationStyle = .fullScreen
//        self.present(mainPageVC, animated: true, completion: nil)
//    }
    
}

extension LoginViewController {
    func login(){
        guard let email = email.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty, let password = password.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            self.showAlertError(title: "Missing Information", message: "To log in you must fill all the information below.")
            return
        }
        
        loginViewModel?.Login(email: email, password: password) { customerLogged in
            
            if customerLogged != nil {
                UserDefaultsManager.shared.setUserStatus(userIsLogged: true)
                print("customer logged in successfully")
                self.showToastMessage(message: "Successful login", color: .green)
                HelperConstant.savPassword(Password: password)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    let mainPageVC = UIStoryboard(name: Storyboards.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.tabScreen.rawValue) as! mainTabBarControllerViewController
                    mainPageVC.modalPresentationStyle = .fullScreen
                    self.present(mainPageVC, animated: true, completion: nil)
                }
                
            }else{
                UserDefaultsManager.shared.setUserStatus(userIsLogged: false)
                self.showAlertError(title: "Failed to log in", message: "Please check your email or password!")
                print("Failed to login")
            }
        }
    }
}
