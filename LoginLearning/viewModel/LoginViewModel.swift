//
//  LoginViewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 29/07/2566 BE.
//

import Foundation

class LoginViewModel {
    
    func postLogin(userName: String,  password: String, completion: @escaping((LoginUser?) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "username": userName,
            "password": password
        ]
        guard let url = URL(string: Endpoints.Gets.login.url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is json
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("Error created data JSON")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil)
                return
            }
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            print(httpRespon.statusCode)
            if httpRespon.statusCode != 200 {
                guard let regisFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("Login failed")
                    return
                }
                onError(regisFailed.description)
                print(regisFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(result.data)
                print(result)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

