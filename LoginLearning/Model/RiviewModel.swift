//
//  RiviewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 19/08/2566 BE.
//

import Foundation

struct ResponRiview: Codable {
    let data: DataIdRiview
}

struct ReviewProduct: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let full_name: String
    let image_url: String
    let created_at: String
}

struct DataIdRiview: Codable {
    let rating_avrg: Double
    let total: Int
    let reviews: [ReviewProduct]
}
