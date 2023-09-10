//
//  Wishlists.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 22/08/2566 BE.
//

import Foundation
struct WishlistList: Codable {
    let data: DataWishlist
}

struct DataWishlist: Codable {
    let total: Int
    let products: [ProducList]?
}

struct WishlistRespon: Codable {
    let data: String
}
