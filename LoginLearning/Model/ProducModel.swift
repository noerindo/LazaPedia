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


