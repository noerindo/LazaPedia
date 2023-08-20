//
//  RiviewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 19/08/2566 BE.
//

import Foundation

struct ReviewProduct: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let full_name: String
    let image_url: String
    let created_at: String
}
