//
//  SplashScreenViewController.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/7/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = .init(name: "22380-e-commerce")
        animationView?.frame = view.bounds
        animationView?.animationSpeed = 0.5
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.play()
        navigationToNextView()
    }
    
    func navigationToNextView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "TabScreenID")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
