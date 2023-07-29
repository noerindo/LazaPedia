//
//  UserModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import Foundation

struct UserModel: Codable {
//    let id: Int
    let email: String
    let password: String
    let phone: String
    let username: String
    let name: FullName
//    let address: Address
}

typealias UserIndex = [UserModel]

struct FullName: Codable {
    let firstname: String
    let lastname: String
}

struct Address: Codable {
    let city: String
    let street: String
    let number: Int
    let zipcode: String
}
