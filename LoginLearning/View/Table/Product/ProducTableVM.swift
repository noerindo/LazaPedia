//
//  ProducTableVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 08/09/2566 BE.
//

import Foundation

class ProducTableVM {
    let networkAPI = NetworkAPI()
    var resultProduct = ProductAll(data: [ProducList]())
    
    var productsCount: Int {
        get {
            return resultProduct.data.count
        }
    }
    
    func loadProductAll(completion: @escaping (() -> Void)) {
        networkAPI.getProducAll { result in
            DispatchQueue.main.async {
                self.resultProduct = result
            }
            completion()
        }
    }
}
