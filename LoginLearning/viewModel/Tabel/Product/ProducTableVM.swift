//
//  ProducTableVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 08/09/2566 BE.
//

import Foundation

class ProducTableVM {
    var resultProduct = ProductAll(data: [ProducList]())
    
    var productsCount: Int {
        get {
            return resultProduct.data.count
        }
    }
    
    func loadProductAll(completion: @escaping (() -> Void)) {
        getProducAll { result in
            DispatchQueue.main.async {
                self.resultProduct = result
            }
            completion()
        }
    }
    
    func getProducAll(completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.productAll.url) else { return }
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
