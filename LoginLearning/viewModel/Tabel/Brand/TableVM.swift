//
//  TableVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 08/09/2566 BE.
//

import Foundation

class TableVM {
    var resultBrand =  AllBrand(description: [Brand]())
    
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
}
