//
//  MainPageViewController.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 04/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class MainPageViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{


    @IBOutlet weak var adsCollectionView: UICollectionView! {
        didSet {
            adsCollectionView.delegate = self
            adsCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var brandsCollectionView: UICollectionView! {
        didSet {
            brandsCollectionView.delegate = self
            brandsCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var BrandsArray = [SmartCollection]()
    var brandsViewModel: BrandsViewModel?
    let indicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .label, padding: 0)
    
    let imageAds = ["1","2","3","4","5","6"]
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFiles()
        
        guard Connectivity.shared.isConnectedToInternet() else {
            self.showAlertForInterNetConnection()
            return
        }
        
        DispatchQueue.main.async {
            self.showActivityIndicator(indicator: self.indicator, startIndicator: true)
        }
        
        brandsViewModel = BrandsViewModel()
        brandsViewModel?.fetchData()
        brandsViewModel?.bindingData = { brands, error in
            if let brands = brands {
                self.BrandsArray = brands
                DispatchQueue.main.async {
                    self.adsCollectionView.reloadData()
                    self.brandsCollectionView.reloadData()
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                }
            }
            
            if let error = error {
                print(error.localizedDescription)
                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            }
        }
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func changeImage() {
            //slider.count
            if counter < imageAds.count {
                let index = IndexPath.init(item: counter, section: 0)
                self.adsCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                //sliderPageController.currentPage = counter
                counter += 1
            } else {
                counter = 0
                let index = IndexPath.init(item: counter, section: 0)
                self.adsCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                //sliderPageController.currentPage = counter
                counter = 1
            }

        }
    
    func registerNibFiles() {
        adsCollectionView.register(UINib(nibName: "AdsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdsCellID")
        
        brandsCollectionView.register(UINib(nibName: "BrandsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "brandsCellID")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == brandsCollectionView){
            print("the number of brand array items is \(BrandsArray.count)")
            return BrandsArray.count
        }else {
            return imageAds.count
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == brandsCollectionView){
        let cell1 = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: "brandsCellID", for: indexPath) as! BrandsCollectionViewCell
        cell1.brandName.text = BrandsArray[indexPath.row].title
        let imgLink = (BrandsArray[indexPath.row].image?.src)!
        let url = URL(string: imgLink)
            cell1.brandLogo.kf.setImage(with: url)
            
            return cell1
        }else {
            let cell2 = adsCollectionView.dequeueReusableCell(withReuseIdentifier: "AdsCellID", for: indexPath) as! AdsCollectionViewCell
            //cell2.backgroundColor = UIColor.blue
            let item = imageAds[indexPath.row]
            cell2.adImage.image = UIImage(named: item)
            return cell2
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == brandsCollectionView){

            let productVC = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "ProductVCID") as! ProductViewController
            
            productVC.brandTitle = BrandsArray[indexPath.row].title
            
            productVC.modalPresentationStyle = .fullScreen
            self.present(productVC, animated: true, completion: nil)
            print("The brand title is \(BrandsArray[indexPath.row].title)")
        }
    }
    
    
    @IBAction func onFavouritesButton(_ sender: Any) {
        let vc = UIStoryboard(name: Storyboards.favourites.rawValue, bundle: nil).instantiateViewController(withIdentifier: StoryboardID.favourites.rawValue) as! FavoritesViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension MainPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        brandsViewModel?.search(searchInput: searchText)
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == adsCollectionView {
            let size = adsCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        } else {
            return CGSize(width: (collectionView.frame.width - 10) / 2, height: 160)
        }
    }
}



