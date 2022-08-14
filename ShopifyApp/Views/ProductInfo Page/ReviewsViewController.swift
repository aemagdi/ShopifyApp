//
//  ReviewsViewController.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/12/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var reviewsTable: UITableView! {
        didSet {
            reviewsTable.delegate = self
            reviewsTable.dataSource = self
        }
    }
    
    let reviewsArray = [Review(image:"https://xsgames.co/randomusers/assets/avatars/male/74.jpg",
                               rating: 4.5,
                               review: "I bought it from here, the quality is remarkable"),
                        Review(image:"https://xsgames.co/randomusers/assets/avatars/female/76.jpg",
                               rating: 4.0,
                               review: "it's well worth the money for thier high quality, I highly recommended"),
                        Review(image: "https://xsgames.co/randomusers/assets/avatars/male/28.jpg",
                               rating: 2.0,
                               review: "I didn't like it")
                        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
    }
    
    func registerNibFile() {
        reviewsTable.register(UINib(nibName: NibFiles.reviewCell.rawValue, bundle: nil), forCellReuseIdentifier: IdentifierCell.reviewCell.rawValue)
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierCell.reviewCell.rawValue, for: indexPath) as! ReviewTableViewCell
        cell.configureCell(user: reviewsArray[indexPath.row])
        return cell
    }
}
