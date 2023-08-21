//
//  ProducModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import Foundation
import UIKit

struct ProductAll: Codable {
    let data: [ProducList]
}
struct ProducList: Codable {
    let id: Int
    let name: String
    let price: Double
    let image_url: String
}

struct AllBrand: Codable {
    let description: [Brand]
}

struct Brand: Codable {
    let id: Int
    let name: String
    let logo_url: String
}

struct ProductDetail: Codable {
    let data: DataProductDetail
}

struct DataProductDetail: Codable {
    let id: Int
    let name: String
    let description: String
    let image_url: String
    let price: Int
    let category: Category
    let size: [Size]
    let reviews: [ReviewProduct]
}

struct Size: Codable {
    let id: Int
    let size: String
}

struct Category: Codable {
    let id: Int
    let category: String
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}

struct SideItem {
    let imageItem: UIImage
    let ketItem: String
}

var cellSide: [SideItem] = [
    SideItem(imageItem: UIImage(named: "Info Circle")!, ketItem: "Account Information"),
    SideItem(imageItem: UIImage(named: "Lock")!, ketItem: "Password"), SideItem(imageItem: UIImage(named: "Bag")!, ketItem: "Order"), SideItem(imageItem: UIImage(named: "Wallet")!, ketItem: "My Cards"), SideItem(imageItem: UIImage(named: "Heart")!, ketItem: "Wishlist"), SideItem(imageItem: UIImage(named: "Setting")!, ketItem: "Settings")
]
struct orderProduc {
    let name: String
    let photo: UIImage
    let countOrder: Int
    let price: Double
}

var orderList: [orderProduc] = [
    orderProduc(name: "Men's Tie-Dye T-Shirt Nike Sportswear", photo: UIImage(named: "phott")!, countOrder: 2, price: 99.2),
    orderProduc(name: "Men's Tie-Dye T-Shirt Nike Sportswear", photo: UIImage(named: "phott")!, countOrder: 1, price: 99.2),
    orderProduc(name: "Men's Tie-Dye T-Shirt Nike Sportswear", photo: UIImage(named: "phott")!, countOrder: 2, price: 99.2),
    
]
