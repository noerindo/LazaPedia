//
//  TableVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 08/09/2566 BE.
//

import Foundation

class TableVM {
    let networkAPI = NetworkAPI()
    var resultBrand =  AllBrand(description: [Brand]())
    
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
}
