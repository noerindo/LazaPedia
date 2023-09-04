//
//  ChangePasswordViewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 03/09/2566 BE.
//

import Foundation

class ChangePasswordViewModel {
    
    func postChangePass(oldPass: String, newPass: String,  completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        let param = [
            "old_password": oldPass,
            "new_password": newPass,
            "re_password": newPass
        ]
        guard let url = URL(string: Endpoints.Gets.changePass.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("Error created data JSON")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            if httpRespon.statusCode != 200 {
                guard let updateFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {return}
                onError(updateFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(ResponSucces.self, from: data)
                completion(result.data.message)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

