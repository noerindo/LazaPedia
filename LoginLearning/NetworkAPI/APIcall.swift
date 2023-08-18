//
//  APIcall.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import Foundation
import Alamofire

class APICall {
    static let sharedApi = APICall()
    private let baseUrl = "https://lazaapp.shop/"
    
    func postLogin(userName: String,  password: String, completion: @escaping((LoginUser?) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "username": userName,
            "password": password
        ]
        guard let url = URL(string: "\(baseUrl)login") else { return }
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
    
    func getProducAll(completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: "\(baseUrl)products") else { return }
        var request = URLRequest(url: url)
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
    
    func getBrand(completion: @escaping ((AllBrand) -> Void)) {
        guard let url = URL(string: "\(baseUrl)brand") else { return }
        var request = URLRequest(url: url)
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
    
            
    func getProfile(completion: @escaping((DataProfileUser?) -> Void), onError: @escaping(String) -> Void) {
        guard let url = URL(string: "\(baseUrl)user/profile") else { return }
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getToken()
        print("Token: \(accesToken)")
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            print(httpRespon.statusCode)
            if httpRespon.statusCode == 200 {
                do {
                    //untuk liat bentuk JSON
//                    let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    print(serializedJson)
                    let result = try JSONDecoder().decode(ProfileUser.self, from: data)
                    completion(result.data)
                } catch {
                    print(error)
                }
            } else {
                print("Error: \(httpRespon.statusCode)")
                guard let getFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else { return }
                onError(getFailed.description)
            }
        }
        task.resume()
    }
    
    func postForgetPass(email: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        guard let url = URL(string: "\(baseUrl)auth/forgotpassword") else { return }
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
        guard let url = URL(string: "\(baseUrl)auth/recover/code") else { return }
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
        guard let url = URL(string:"\(baseUrl)auth/recover/password?email=\(email)&code=\(code)" ) else { return }
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
    
    func postRegister(email: String, userName: String, password: String, completion: @escaping((ResponRegisSucces?) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "full_name": userName,
            "email": email,
            "username": userName,
            "password": password
        ]
        
        // create url request
        guard let url = URL(string: "\(baseUrl)register") else { return }
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
            if httpRespon.statusCode != 201 {
                guard let regisFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("Regis failed")
                    return
                }
                onError(regisFailed.description)
                print(regisFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(ResponRegisSucces.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
