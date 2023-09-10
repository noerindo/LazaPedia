//
//  UserModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import Foundation

struct ResponRegisSucces: Codable {
    let status: String
    let data: RegisterUser
}

struct RegisterUser: Codable {
    let id: Int
    let email: String
    let username: String
}

struct ResponFailed : Codable {
    let status: String
    let description: String
}
struct ResponUpdate: Codable {
    let status: String
}

struct profileUpdateRespon: Codable {
    let status: String
    let data: DataProfileUser
}

struct LoginResponse: Codable {
    let status: String
    let data: LoginUser
}

struct LoginUser: Codable {
    let access_token: String
    let refresh_token: String
}

struct DataProfileUser: Codable {
    let id: Int
    let username: String
    let email: String
    let full_name: String
    let image_url: String?
}

//struct DataProfilUserImage: Codable {
//    let id: Int
//    let username: String
//    let email: String
//    let full_name: String
//    let image_url: String
//}
//
//struct ProfileUpdate: Codable {
//    let data: DataProfilUserImage
//}

struct ProfileUser: Codable {
    let data: DataProfileUser
}
 
struct ResponSucces: Codable
{
    let status: String
    let data: MessageForgot
}

struct MessageForgot : Codable {
    let message: String
}

struct Address: Codable {
    let city: String
    let street: String
    let number: Int
    let zipcode: String
}

typealias AdressUser = [Address]

