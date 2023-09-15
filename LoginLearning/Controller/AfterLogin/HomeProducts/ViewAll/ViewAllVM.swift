//
//  ViewAllVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class ViewAllVM {
    let networkAPI = NetworkAPI()
    var resultProduct = ProductAll(data: [ProducList]())
    var resultBrand =  AllBrand(description: [Brand]())
    
    private(set) var kodeLabel: String
    
    init(kodeLabel: String) {
        self.kodeLabel = kodeLabel
    }
    
    var brandCount: Int {
        get {
            return resultBrand.description.count
        }
    }
    
    func loadBrand(completion: @escaping (() -> Void)) {
        networkAPI.getBrand { result in
            DispatchQueue.main.async {
                self.resultBrand = result
            }
            completion()
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
