//
//  ResetPasswordVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 06/09/2566 BE.
//

import Foundation

class  ResetPasswordVM {
    
    private(set) var codeEmail: String
    private(set) var email: String
    
    init(codeEmail: String, email: String) {
        self.codeEmail = codeEmail
        self.email = email
    }

    
    func postNewPassword(newPass: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        let param = [
            "new_password": newPass,
            "re_password": newPass
        ]
        guard let url = URL(string: Endpoints.Gets.newPassword(email: email, code: codeEmail).url ) else { return }
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
