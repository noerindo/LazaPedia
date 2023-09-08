//
//  AddAdressViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class AddAdressViewVM {
    
   private(set) var selectedData: DataAdress
    
    init(selectedData: DataAdress) {
        self.selectedData = selectedData
    }
    
    func putAdress(id: Int,country: String, city: String, receiver_name: String, phone_number: String, is_primary: Bool,completion: @escaping (String) -> Void,  onError: @escaping((String) -> Void)) {
        let param = [
            "country": country,
            "city":city,
            "receiver_name":receiver_name,
            "phone_number":phone_number,
            "is_primary": is_primary
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.deleteAdress(id: id).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("error created adress")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            if httpRespon.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(ResponPut.self, from: data)
                    completion(result.status)
                } catch {
                    print(error)
                }
            } else {
                guard let responFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {return}
                onError(responFailed.description)
            }
        }
        task.resume()
    }
    
    func postAdress(country: String, city: String, receiver_name: String, phone_number: String, is_primary: Bool, completion: @escaping((String) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "country": country,
            "city":city,
            "receiver_name":receiver_name,
            "phone_number":phone_number,
            "is_primary": is_primary
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.adress.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("error created adress")
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
                let result = try JSONDecoder().decode(ResponUpdate.self, from: data)
                completion(result.status)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
