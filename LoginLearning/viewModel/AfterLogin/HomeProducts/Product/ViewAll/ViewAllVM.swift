//
//  ViewAllVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class ViewAllVM {
    
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
        getBrand { result in
            DispatchQueue.main.async {
                self.resultBrand = result
            }
            completion()
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
    
    func getBrand(completion: @escaping ((AllBrand) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.brandAll.url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(AllBrand.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        task.resume()
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
