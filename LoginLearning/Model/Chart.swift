//
//  Chart.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import Foundation

struct ChartUpdateCell: Codable {
    let data: DataChart?
}

struct CheckoutBody: Codable {
    let products: [DataProduct]
    let addressId: Int
    let bank: String
    
    private enum CodingKeys: String, CodingKey {
        case products = "products"
        case addressId = "address_id"
        case bank = "bank"
    }
}

struct DataProduct: Codable {
    let id: Int
    let quantity: Int
}

struct DataChart: Codable {
    let user_id: Int
    let product_id: Int
    let size_id: Int
    let quantity: Int
}

struct AllChart: Codable {
    let data: DataAllChart
}

struct DataAllChart: Codable {
    let products: [ProductChart]?
    let order_info: OrderInfo
}

struct ProductChart: Codable {
    let id: Int
    let product_name: String
    let image_url: String
    let price: Int
    let brand_name: String
    let quantity: Int
    let size: String
}

struct OrderInfo: Codable {
    let sub_total: Int
    let shipping_cost: Int
    let total: Int
}
