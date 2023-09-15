//
//  DetailCategoryVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class DetailCategoryVM {
    let networkAPI = NetworkAPI()
    var resultBrandProduct = ProductAll(data: [ProducList]())
    
    private(set) var brandName: String
    
    init(brandName: String) {
        self.brandName = brandName
    }
    
    var allBrandProductCount: Int {
        get {
            return resultBrandProduct.data.count
        }
    }
    
    func loadBrandProductAll(nameBrand: String, completion: @escaping (() -> Void)) {
        networkAPI.getBrandProduct(nameBrand: nameBrand) { data in
            DispatchQueue.main.async {
                self.resultBrandProduct = data
            }
            completion()
        }
    }
    
}
