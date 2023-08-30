//
//  Adress.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import Foundation

struct GetAllAdres: Codable {
    let data: [DataAdress]
}
struct DataAdress: Codable {
    let id: Int
    let country: String
    let city: String
    let receiver_name: String
    let phone_number: String
    let user_id: Int
    let is_primary: Bool?
    let user:User
}

struct User: Codable {
    let id: Int
    let username: String
    let full_name: String
    let email: String
    let updated_at: String
}
