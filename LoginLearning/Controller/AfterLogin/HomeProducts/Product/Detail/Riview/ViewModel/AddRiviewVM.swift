//
//  AddRiviewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class AddRiviewVM {
    let networkAPI = NetworkAPI()
    private(set) var idProduct: Int
    
    init(idProduct: Int) {
        self.idProduct = idProduct
    }
    
    func addRiview(comment: String, rating: Double, completion: @escaping((String) -> Void), onError: @escaping(String) -> Void) {
        networkAPI.postRiview(id: idProduct, comment: comment, rating: rating) { result in
            completion(result)
        } onError: { error in
            onError(error)
        }
    }
}
