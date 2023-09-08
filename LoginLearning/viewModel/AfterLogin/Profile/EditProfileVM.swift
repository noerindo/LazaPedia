//
//  EditProfileVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class EditProfileVM{
   
    private(set) var updateProfile: DataProfileUser
    
    init(updateProfile: DataProfileUser) {
        self.updateProfile = updateProfile
    }
    
    func putProfile(fullName: String, username: String, email: String, media: Media?,
                    completion: @escaping (String) -> Void, onError: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.putProfile.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        print("Token: \(accesToken)")
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let boundary = PutImageAPI.getBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = PutImageAPI.getMultipartFormData(
            withParameters: [
                "full_name": fullName,
                "username": username,
                "email": email
            ],
            media: media,
            boundary: boundary)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            print(httpRespon.statusCode)
            if httpRespon.statusCode == 200 {
                do {
                    //untuk liat bentuk JSON
//                    let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    print(serializedJson)
                    let result = try JSONDecoder().decode(ResponUpdate.self, from: data)
                    completion(result.status)
                    print("Berhasil update profile")
                } catch {
                    print(error)
                }
            }  else {
                print("Error: \(httpRespon.statusCode)")
                guard let getFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else { return }
                onError(getFailed.description)
            }
        }
        task.resume()
    }
    
}
