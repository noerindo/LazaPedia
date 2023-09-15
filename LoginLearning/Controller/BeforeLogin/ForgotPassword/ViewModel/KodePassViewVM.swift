//
//  KodePassViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 06/09/2566 BE.
//

import Foundation

class KodePassViewVM {
    private let networkAPI = NetworkAPI()
    private(set) var emailForgot: String
    
    init(emailForgot: String) {
        self.emailForgot = emailForgot
    }
    
    func kodeForgot(code: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        networkAPI.postCodeForgot(emailForgot: emailForgot, code: code) { result in
            completion(result)
        } onError: { error in
            onError(error)
        }

    }
    
    
}
