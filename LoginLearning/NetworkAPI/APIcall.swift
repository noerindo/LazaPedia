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
    
//    func postParam(email: String, username: String, password: String) {
//        let params: Parameters = [
//            "full_name": username,
//            "email": email,
//            "username": username,
//            "password": password
//        ]
//
//        AF.request("\(baseUrl)register", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { respon in
//            print(respon)
//            print(respon.response?.statusCode)
//
//            switch respon.result{
//            case .success(let data):
//                print("registerSucess=",data)
//                do {
////                    guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
////                                           print("Error: Cannot convert data to JSON object")
////                                           return
////                    }
////                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
////                        print("Error: Cannot convert JSON object to Pretty JSON data")
////                        return
////                    }
////                    if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8){
////                        let dataini = try! JSONDecoder().decode(UserModel.self, from: respon.data!)
////                        print("ini \(dataini)")
////                    } else {
////                        print("Error: Could print JSON in String")
////                        return
////                    }
////                    let jsonData = data as! Any
////                                        print("ini ini, \(jsonData)")
//
//                } catch {
//                    print("Error: Trying to convert JSON data to string")
//                    return
//                }
//            case .failure(let error):
//                print(error)
//            }
//
//
//        }
//    }
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
            if httpRespon.statusCode != 201 {
                guard let regisFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("Login failed")
                    return
                }
                onError(regisFailed.description)
                print(regisFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(LoginUser.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        task.resume()

        
    }
    
    func getProfile(completion: @escaping((LoginUser?) -> Void)) {
        guard let url = URL(string: "\(baseUrl)user/profile") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let result = try? JSONDecoder().decode(LoginUser.self, from: data)
//                        completion(result)
//                } catch {
//                    print(error)
//                }
//            }
//
//        }
    }
    
    func postForgetPass(email: String, completion: @escaping(String) -> Void) {
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
            if httpRespon.statusCode == 200 {
                guard let regisFailed = try? JSONDecoder().decode(ResponForgotPass.self, from: data) else {
                    completion("email failed")
                    return
                }
                completion(regisFailed.data.message)
                print(regisFailed.data.message)
                return
            }        }
        task.resume()
    }
    
    func postCodeForgot(email: String, code: String,completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
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
            if httpRespon.statusCode == 202 {
                guard let regisSucces = try? JSONDecoder().decode(ResponSucces.self, from: data) else {
                    completion("code gagal")
                    return
                }
                completion(regisSucces.data.message)
                return
            } else {
                guard let regisFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
            }        }
        task.resume()
        
        
    }
    
//    func postNewPassword(newPass: String, confirPass: String, completion: @escaping)
    
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
