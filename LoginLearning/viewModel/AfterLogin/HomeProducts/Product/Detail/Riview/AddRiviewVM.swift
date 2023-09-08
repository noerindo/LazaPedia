//
//  AddRiviewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class AddRiviewVM {
    
    private(set) var idProduct: Int
    
    init(idProduct: Int) {
        self.idProduct = idProduct
    }
    
    func postRiview(comment: String, rating: Double, completion: @escaping((String) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "comment": comment,
            "rating": rating
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.riview(id: idProduct).url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("Error created riview data JSON")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            if httpRespon.statusCode != 201 {
                guard let createFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("addRiview Failed")
                    return
                }
                onError(createFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(ResponPut.self, from: data)
                completion(result.status)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
