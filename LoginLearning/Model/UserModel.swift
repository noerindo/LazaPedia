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


struct LoginUser: Codable {
    let access_token: String
    let refresh_token: String
}

struct DataProfile: Codable {
    let id: Int
    let username: String
    let password: String
    let email: String
    let full_name: String
    let image_url: String
}

struct Profile: Codable {
    let data: DataProfile
}
 
struct ResponSucces: Codable
{
    let status: String
    let data: MessageForgot
}

struct MessageForgot : Codable {
    let message: String
}
