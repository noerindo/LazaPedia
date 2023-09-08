//
//  KodePassViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 06/09/2566 BE.
//

import Foundation

class KodePassViewVM {
    
    private(set) var emailForgot: String
    
    init(emailForgot: String) {
        self.emailForgot = emailForgot
    }
    
    func postCodeForgot(code: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        let param = [
            "email": emailForgot,
            "code": code
        ]
        guard let url = URL(string: Endpoints.Gets.codeForgot.url) else { return }
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
                return
            }
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            print("hasil code: \(httpRespon.statusCode)")
            if httpRespon.statusCode != 202 {
                guard let result = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("code gagal")
                    return
                }
                completion(result.description)
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
