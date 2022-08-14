//
//  DatabaseManager.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/6/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager: DatabaseService {
    
    func getShoppingCartProductList(appDelegate: AppDelegate, userId: Int, complition: @escaping ([Product]?, Error?)->Void) {
            var productList = [Product]()
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCD")
            fetchRequest.predicate = NSPredicate(format: "userID = \(userId)")
            do{
                let productArray = try managedContext.fetch(fetchRequest)
                print("get products from shopping cart successfully")
                for product in productArray{
                    let id = product.value(forKey: "id") as! Int
                    let count = product.value(forKey: "count") as! Int
                    let userID = product.value(forKey: "userID") as! Int
                    let price = product.value(forKey: "price") as! String
                    let quantity = product.value(forKey: "quantity") as! Int
                    let title = product.value(forKey: "title") as! String
                    let imgUrl = product.value(forKey: "imgUrl") as! String
                    let product = Product(id: id, title: title, description: "", vendor: nil, productType: "", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: id, productID: 0, title: "", price: price,quantity: quantity)], tags: "", image: ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: ""),count: count, userID: userID)
                    productList.append(product)
                }
                complition(productList, nil)
            }catch{
                print("failed to load products from shopping cart from core data \(error.localizedDescription)")
                complition(nil, error)
            }
        }
    
    
    func getItemFromShoppingCartProductList(appDelegate: AppDelegate, product: Product, complition: @escaping ([Product]?, Error?)->Void) {
        var productList = [Product]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCD")
        fetchRequest.predicate = NSPredicate(format: "userID = \(product.userID) AND id = \(product.id)")
        do{
            let productArray = try managedContext.fetch(fetchRequest)
            print("get one product from shopping cart successfully")
            for product in productArray{
                let id = product.value(forKey: "id") as! Int
                let count = product.value(forKey: "count") as! Int
                let userID = product.value(forKey: "userID") as! Int
                let price = product.value(forKey: "price") as! String
                let quantity = product.value(forKey: "quantity") as! Int
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "imgUrl") as! String
                let product = Product(id: id, title: title, description: "", vendor: nil, productType: "", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: id, productID: 0, title: "", price: price,quantity: quantity)], tags: "", image: ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: ""),count: count, userID: userID)
                productList.append(product)
            }
            complition(productList, nil)
        }catch{
            print("failed to load one product from shopping cart from core data \(error.localizedDescription)")
            complition(nil, error)
        }
    }
    
    func addProduct(appDelegate: AppDelegate, product: Product) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ProductCD", in: managedContext)
        let productCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        productCD.setValue(product.id , forKey: "id")
        productCD.setValue(product.count + 1, forKey: "count")
        productCD.setValue(product.userID, forKey: "userID")
        productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
        productCD.setValue(product.varients?[0].quantity ?? "0", forKey: "quantity")
        productCD.setValue(product.title, forKey: "title")
        productCD.setValue(product.image.src, forKey: "imgUrl")
        do{
            try managedContext.save()
            print("product saved successfully")
        }catch let error as NSError{
            print("failed to add product to core data \(error.localizedDescription)")
        }
    }
    
    func updateProductFromList(appDelegate: AppDelegate, product: Product) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCD")
        fetchRequest.predicate = NSPredicate(format: "id = \(product.id) AND userID = \(product.userID)")
        do{
            let productsArray = try managedContext.fetch(fetchRequest)
            for productCD in productsArray{
                    
                productCD.setValue(product.id , forKey: "id")
                productCD.setValue(product.count, forKey: "count")
                productCD.setValue(product.userID, forKey: "userID")
                productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
                productCD.setValue(product.varients?[0].quantity ?? "0", forKey: "quantity")
                productCD.setValue(product.title, forKey: "title")
                productCD.setValue(product.image.src, forKey: "imgUrl")
            }
            try managedContext.save()
            print("product updated successfully")
            } catch {
            print("failed to update product in core data \(error.localizedDescription)")
            }
        }
    
    func deleteProduct(appDelegate: AppDelegate, product: Product) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCD")
        fetchRequest.predicate = NSPredicate(format: "id = \(product.id) AND userID = \(product.userID)")
        do{
            let productsArray = try managedContext.fetch(fetchRequest)
            for product in productsArray {
                managedContext.delete(product)
            }
            try managedContext.save()
            print("product deleted successfully")
        }catch{
            print("failed to delete product from core data \(error)")
        }
    }
    
    func emptyCart(appDelegate: AppDelegate, userId: Int){
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductCD")
        fetchRequest.predicate = NSPredicate(format: "userID = \(userId)")
        do{
            let productCDArray = try managedContext.fetch(fetchRequest)
            for product in productCDArray {
                managedContext.delete(product)
            }
            try managedContext.save()
            print("products deleted successfully")
        }catch{
            print("failed to delete product from core data \(error)")
        }
    }
    
    func addFavourite(appDelegate: AppDelegate, product: Product) {
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteCD", in: managedContext)
            
        let productCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        productCD.setValue(product.id , forKey: "id")
        productCD.setValue(product.userID , forKey: "userID")
        productCD.setValue(product.varients?[0].price ?? "0.0", forKey: "price")
        productCD.setValue(product.title, forKey: "title")
        productCD.setValue(product.image.src, forKey: "imgUrl")
        do{
            try managedContext.save()
            print("favourite saved successfully")
        }catch let error as NSError{
            print("failed to add favourite to core data \(error.localizedDescription)")
        }
    }
        
    func getFavourites(appDelegate: AppDelegate, userId: Int, complition: @escaping ([Product]?, Error?)->Void) {
        var favouriteList = [Product]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCD")
        fetchRequest.predicate = NSPredicate(format: "userID = \(userId)")
        do{
            let productArray = try managedContext.fetch(fetchRequest)
            print("get products from favourites successfully")
            for product in productArray{
                let id = product.value(forKey: "id") as! Int
                let userID = product.value(forKey: "userID") as! Int
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "imgUrl") as! String
                let product = Product(id: id, title: title, description: "", vendor: nil, productType: "", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: id, productID: 0, title: "", price: price,quantity: 0)], tags: "", image: ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: ""), count: 0, userID: userID)
    
                    favouriteList.append(product)
            }
            complition(favouriteList, nil)
        }catch{
            print("failed to load favourites from core data \(error.localizedDescription)")
            complition(nil, error)
        }
    }
    
    func getItemFromFavourites(appDelegate: AppDelegate, product: Product, complition: @escaping ([Product]?, Error?)->Void) {
        var favouriteList = [Product]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCD")
        fetchRequest.predicate = NSPredicate(format: "userID = \(product.userID) AND id = \(product.id)")
        do{
            let productArray = try managedContext.fetch(fetchRequest)
//            print("get one product from favourites successfully")
            for product in productArray{
                let id = product.value(forKey: "id") as! Int
                let userID = product.value(forKey: "userID") as! Int
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "imgUrl") as! String
                let product = Product(id: id, title: title, description: "", vendor: nil, productType: "", images: [ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: "")], options: nil, varients: [Varient(id: id, productID: 0, title: "", price: price,quantity: 0)], tags: "", image: ProductImage(id: id, productID: 1, position: 1, width: 1, height: 1, src: imgUrl, graphQlID: ""), count: 0, userID: userID)
    
                    favouriteList.append(product)
            }
            complition(favouriteList, nil)
        }catch{
            print("failed to load one product from favourites from core data \(error.localizedDescription)")
            complition(nil, error)
        }
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Product) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCD")
        fetchRequest.predicate = NSPredicate(format: "id = \(product.id) AND userID = \(product.userID)")
        do{
            let productsArray = try managedContext.fetch(fetchRequest)
            for product in productsArray {
                managedContext.delete(product)
            }
            try managedContext.save()
            print("product deleted successfully")
        }catch{
            print("failed to delete favourite from core data \(error)")
        }
    }
    
}
