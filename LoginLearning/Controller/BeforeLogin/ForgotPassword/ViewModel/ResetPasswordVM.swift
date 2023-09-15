//
//  ResetPasswordVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 06/09/2566 BE.
//

import Foundation

class  ResetPasswordVM {
    
    private let networkApi = NetworkAPI()
    
    private(set) var codeEmail: String
    private(set) var email: String
    
    init(codeEmail: String, email: String) {
        self.codeEmail = codeEmail
        self.email = email
    }
    
    func resetPass(newPass: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        networkApi.postNewPassword(email: email, codeEmail: codeEmail, newPass: newPass) { result in
            completion(result)
        } onError: { error in
            onError(error)
        }

    }
    
}
