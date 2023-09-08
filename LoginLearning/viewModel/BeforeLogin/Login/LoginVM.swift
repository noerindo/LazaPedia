//
//  LoginVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class LoginVM {
    
    //login Register
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
            
            if httpRespon.statusCode != 200 {
                guard let regisFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("Login failed")
                    return
                }
                onError(regisFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(result.data)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    //get profile
    func getProfile(token: String, completion: @escaping((DataProfileUser?) -> Void), onError: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.profile.url) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            print(httpRespon.statusCode)
            if httpRespon.statusCode == 200 {
                do {
                    //untuk liat bentuk JSON
                    let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(serializedJson)
                    let result = try JSONDecoder().decode(ProfileUser.self, from: data)
                    completion(result.data)
                    RememberUser().setCurrentProfile(profile: data)
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
    
    //refresh Token
    func getRefreshToken(refreshToken: String) {
            guard let url = URL(string: Endpoints.Gets.refreshToken.url) else {return}
            var request = URLRequest(url: url)
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "X-auth-refresh")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                
                do {
                    let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                    KeychainManager.shared.deleteToken()
                    KeychainManager.shared.deleteResfreshToken()
                    KeychainManager.shared.saveRefreshToken(token: result.data.refresh_token)
                    KeychainManager.shared.saveToken(token: result.data.access_token)
                    
                    
                } catch {
                    print("ini lohhh \(error)")
                }
            }
            task.resume()
        }
}
