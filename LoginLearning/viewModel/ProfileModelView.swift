//
//  ProfileModelView.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 19/08/2566 BE.
//

import Foundation

class ProfileModelView {
    
    
    
    func getProfile(completion: @escaping((DataProfileUser?) -> Void), onError: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.profile.url) else { return }
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
    
}
