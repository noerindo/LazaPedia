//
//  DetailCategoryVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class DetailCategoryVM {
    
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
        getBrandProduct(nameBrand: nameBrand) { data in
            DispatchQueue.main.async {
                self.resultBrandProduct = data
            }
            completion()
        }
    }
    
    func getBrandProduct(nameBrand: String, completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.brandProduct(nameBrand: nameBrand).url) else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(ProductAll.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
