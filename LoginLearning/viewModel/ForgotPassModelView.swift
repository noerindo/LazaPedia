//
//  ForgotPassModelView.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 19/08/2566 BE.
//

import Foundation

class ForgotPassModelView {
    
    func postForgetPass(email: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.forgotPassword.url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is json
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["email": email])
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
                let result = try JSONDecoder().decode(ResponSucces.self, from: data)
                completion(result.data.message)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func postCodeForgot(email: String, code: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        let param = [
            "email":email,
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
    func postNewPassword(newPass: String, confirPass: String, email: String, code: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        let param = [
            "new_password": newPass,
            "re_password": confirPass
        ]
        guard let url = URL(string: Endpoints.Gets.newPassword(email: email, code: code).url ) else { return }
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
            if httpRespon.statusCode != 200 {
                guard let result = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    completion("code gagal")
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
