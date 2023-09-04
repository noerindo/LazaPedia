//
//  APIcall.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import Foundation

struct API {
    static let baseUrl = "https://lazaapp.shop/"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    enum Gets: Endpoint {
        case login
        case register
        case forgotPassword
        case codeForgot
        case newPassword(email: String, code: String)
        case profile
        case putProfile
        case productAll
        case producDetail(id: Int)
        case riview(id: Int)
        case brandAll
        case brandProduct(nameBrand: String)
        case addWishList(idProduct: Int)
        case wishlistAll
        case allChart
        case chart(idProduct: Int, idSize: Int)
        case adress
        case deleteAdress(id: Int)
        case sendVerifikasi
        case size
        case refreshToken
        case changePass
        
        public var url: String {
            switch self {
            case .login:
                return "\(API.baseUrl)login"
            case .register:
                return "\(API.baseUrl)register"
            case .forgotPassword:
                return "\(API.baseUrl)auth/forgotpassword"
            case .codeForgot:
                return "\(API.baseUrl)auth/recover/code"
            case .newPassword(email: let email, code: let code):
                return "\(API.baseUrl)auth/recover/password?email=\(email)&code=\(code)"
            case .profile:
                return "\(API.baseUrl)user/profile"
            case .producDetail(id: let id):
                return "\(API.baseUrl)products/\(id)"
            case .productAll:
                return"\(API.baseUrl)products"
            case .brandAll:
                return"\(API.baseUrl)brand"
            case .riview(id: let id):
                return "\(API.baseUrl)products/\(id)/reviews"
            case .brandProduct(nameBrand: let nameBrand):
                return "\(API.baseUrl)products/brand?name=\(nameBrand)"
            case .addWishList(idProduct: let idProduct):
                return "\(API.baseUrl)wishlists?ProductId=\(idProduct)"
            case .wishlistAll:
                return"\(API.baseUrl)wishlists"
            case .putProfile:
                return "\(API.baseUrl)user/update"
            case .allChart:
                return "\(API.baseUrl)carts"
            case .chart(idProduct: let idProduct, idSize: let idSize):
                return "\(API.baseUrl)carts?ProductId=\(idProduct)&SizeId=\(idSize)"
            case .adress:
                return "\(API.baseUrl)address"
            case .sendVerifikasi:
                return "\(API.baseUrl)auth/confirm/resend"
            case .size:
                return "\(API.baseUrl)size"
            case .deleteAdress(id: let id):
                return "\(API.baseUrl)address/\(id)"
            case .refreshToken:
                return "\(API.baseUrl)auth/refresh"
            case .changePass:
                return "\(API.baseUrl)user/change-password"
            }
        }
    }
}

