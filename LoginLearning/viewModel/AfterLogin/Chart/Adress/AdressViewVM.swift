//
//  AdressViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class AdressViewVM {
   
    
    var resultAdress = GetAllAdres(data: [DataAdress]())
    
    var adressCount: Int {
        get {
            return resultAdress.data.count
        }
    }
    
    func loadAdress(completion: @escaping((GetAllAdres) -> Void)) {
        getAdress { adress in
            DispatchQueue.main.async {
                let Primary = adress.data.filter { $0.is_primary != nil}
                let unPrimary = adress.data.filter { $0.is_primary == nil}
                self.resultAdress.data = Primary + unPrimary
                completion(adress)
            }
        }
    }
    
    func getAdress (completion: @escaping((GetAllAdres) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.adress.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data is nil")
                return
            }
            do {
                let result = try JSONDecoder().decode(GetAllAdres.self, from: data)
                print("Completion")
                completion(result)
            } catch {
                print("get Wishlist failed; \(error)")
            }
        }
        task.resume()
    }
    
    func deleteAdress(id: Int,completion: @escaping((String) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.deleteAdress(id: id).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else {return}
            if httpRespon.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(WishlistRespon.self, from: data)
                    completion(result.data)
                } catch {
                    print("error delete")
                }
            }
        }
        task.resume()

    }
    
}
