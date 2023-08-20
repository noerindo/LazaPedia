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
        case productAll
        case producDetail(id: Int)
        case brandAll
        case searchProduct(name: String)
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
            case .searchProduct(name: let name):
                return "\(API.baseUrl)products?search=\(name)"
            }
        }
    }
}
