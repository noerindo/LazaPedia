//
//  NetworkAPI.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 08/09/2566 BE.
//

import Foundation

class NetworkAPI {
    static let shared = NetworkAPI()

    //MARK: LOGIN
    //login Register
    
    func postRegister(email: String, userName: String, password: String, completion: @escaping((ResponRegisSucces?) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "full_name": userName,
            "email": email,
            "username": userName,
            "password": password
        ]
        
        // create url request
        guard let url = URL(string: Endpoints.Gets.register.url) else { return }
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
                    let result = try JSONDecoder().decode(DataProfileUser.self, from: data)
                    completion(result)
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
                    let result = try JSONDecoder().decode(profileUpdateRespon.self, from: data)
                    completion(result.status)
                    KeychainManager.shared.deleteProfileFromKeychain()
                    KeychainManager.shared.saveProfileToKeychain(profile: result.data)
                } catch {
                    print(error)
                }
            }  else {
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

    // sendEmail
    func postVerifikasiAccount(email: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.sendVerifikasi.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["email": email])
        } catch {
            print("Error send verifikasi")
        }
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }

            if httpRespon.statusCode != 200 {
                guard let resendFailed = try? JSONDecoder().decode(ResponSucces.self, from: data) else {return}
                onError(resendFailed.data.message)

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

    //ForgotPass
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
    
    func postNewPassword(email: String, codeEmail: String,newPass: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
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
    
    func postCodeForgot(emailForgot: String, code: String, completion: @escaping(String) -> Void, onError: @escaping(String) -> Void) {
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
    
    //Adress
    func putAdress(id: Int,country: String, city: String, receiver_name: String, phone_number: String, is_primary: Bool,completion: @escaping (String) -> Void,  onError: @escaping((String) -> Void)) {
        let param = [
            "country": country,
            "city":city,
            "receiver_name":receiver_name,
            "phone_number":phone_number,
            "is_primary": is_primary
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.deleteAdress(id: id).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("error created adress")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            if httpRespon.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(ResponPut.self, from: data)
                    completion(result.status)
                } catch {
                    print(error)
                }
            } else {
                guard let responFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {return}
                onError(responFailed.description)
            }
        }
        task.resume()
    }
    
    func postAdress(country: String, city: String, receiver_name: String, phone_number: String, is_primary: Bool, completion: @escaping((String) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "country": country,
            "city":city,
            "receiver_name":receiver_name,
            "phone_number":phone_number,
            "is_primary": is_primary
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.adress.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("error created adress")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }

            if httpRespon.statusCode != 201 {
                guard let createFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("addRiview Failed")
                    return
                }
                onError(createFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(ResponUpdate.self, from: data)
                completion(result.status)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func getAdress (completion: @escaping((GetAllAdres) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.adress.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data is nil")
                return
            }
            do {
                let result = try JSONDecoder().decode(GetAllAdres.self, from: data)
                print("Completion")
                completion(result)
            } catch {
                print("get Wishlist failed; \(error)")
            }
        }
        task.resume()
    }
    
    func deleteAdress(id: Int,completion: @escaping((String) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.deleteAdress(id: id).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else {return}
            if httpRespon.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(WishlistRespon.self, from: data)
                    completion(result.data)
                } catch {
                    print("error delete")
                }
            }
        }
        task.resume()

    }
    
    //Wishlist
    func getWishlist(completion: @escaping((WishlistList?) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.wishlistAll.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data is nil")
                return
            }
            do {
                let result = try JSONDecoder().decode(WishlistList.self, from: data)
                completion(result)
            } catch {
                print("get Wishlist failed; \(error)")
            }
        }
        task.resume()
    }
    
    func putWishlist(id: Int, completion: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.addWishList(idProduct: id).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(WishlistRespon.self, from: data)
                //                result.data.reviews = result.data
                completion(result.data)
            } catch {
                print("riview Gagal: \(error)")
            }
        }
        task.resume()
    }

    // BrandProduct
    
    func getBrandProduct(nameBrand: String, completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.brandProduct(nameBrand: nameBrand).url) else {return}
        let request = URLRequest(url: url)
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

    //Riview
    func postRiview(id:Int,comment: String, rating: Double, completion: @escaping((String) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "comment": comment,
            "rating": rating
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.riview(id: id).url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("Error created riview data JSON")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            if httpRespon.statusCode != 201 {
                guard let createFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("addRiview Failed")
                    return
                }
                onError(createFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(ResponPut.self, from: data)
                completion(result.status)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getAllRiview(id: Int, completion: @escaping((ResponRiview) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.riview(id: id).url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(ResponRiview.self, from: data)
                completion(result)
            } catch {
                print("riview Gagal: \(error)")
            }
        }
        task.resume()
    }
    
    //Product
    func getProducAll(completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.productAll.url) else { return }
        let request = URLRequest(url: url)
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

    func getDetailProduct(id: Int, completion: @escaping((ProductDetail) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.producDetail(id: id).url) else { return }
        let request = URLRequest(url: url)
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                //untuk liat bentuk JSON
//                            let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                            print(serializedJson)
                let result = try JSONDecoder().decode(ProductDetail.self, from: data)
                completion(result)
            } catch {
                print("ini erro loh\(error)")
            }
        }
        task.resume()
    }
    
    func deletProductChart(idProduct: Int, idSize: Int, completion: @escaping((String) -> Void)) {
         guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
         var request = URLRequest(url: url)
         request.httpMethod = "DELETE"
         let accesToken = KeychainManager.shared.getTokenValid()
         request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             
             guard let httpRespon = response as? HTTPURLResponse else { return}
             guard let data = data else {return}
             print("kode delete:  \(httpRespon.statusCode)")
             if httpRespon.statusCode == 200 {
                 do {
                     let result = try JSONDecoder().decode(WishlistRespon.self, from: data)
                     completion(result.data)
                 } catch {
                     print("error delete")
                 }
             }
         }
         task.resume()
     }
    
    func putProductChart(idProduct: Int, idSize: Int, completion: @escaping(DataChart?) -> Void, onError: @escaping (String) -> Void)  {
            guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let accesToken = KeychainManager.shared.getTokenValid()
            request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let httpRespon = response as? HTTPURLResponse else { return}
                guard let data = data else {return}
                print("Kode pur \(httpRespon.statusCode)")
                if httpRespon.statusCode != 200 {
                    onError("\(error)")
                    return
                }
                if let result = try? JSONDecoder().decode(ChartUpdateCell.self, from: data) {
                    completion(result.data)
                } else if let result = try? JSONDecoder().decode(ResponPut.self, from: data) {
                    onError(result.status)
                }
            }
            task.resume()
        }
        
    
    func postChecOut(product: [DataProduct], address_id: Int, onError: @escaping (String) -> Void, completion: @escaping () -> Void) {
            
            guard let url = URL(string: Endpoints.Gets.chekOut.url) else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let accesToken = KeychainManager.shared.getTokenValid()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
            
            do {
                let checkoutBody = CheckoutBody(products: product, addressId: address_id, bank: "bni")
                let encoder = JSONEncoder()
                let json = try encoder.encode(checkoutBody)
                request.httpBody = json
            } catch {
                print("Error checkOut riview data JSON")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in

                guard let httpRespon = response as? HTTPURLResponse else { return}
                guard let data = data else { return }
                print("iniiii cekout : \(httpRespon.statusCode)")

                if httpRespon.statusCode != 201 {
                    guard let createFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                        onError("addRiview Failed")
                        return
                    }
                    onError(createFailed.description)
                    return
                }
                completion()
            }
            task.resume()
        }
    
    //Chart
    func postChart(idProduct: Int, idSize: Int, completion: @escaping((ChartUpdateCell?) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            do {
                let result = try JSONDecoder().decode(ChartUpdateCell.self, from: data)
                completion(result)
            } catch {
                print("Gagal Add Chart")
            }
        }
        task.resume()
    }
    
    func getAllChart(completion: @escaping((AllChart?) -> Void))  {
        guard let url = URL(string: Endpoints.Gets.allChart.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
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
                    let result = try JSONDecoder().decode(AllChart.self, from: data)
                    completion(result)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //Brand
    func getBrand(completion: @escaping ((AllBrand) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.brandAll.url) else { return }
        let request = URLRequest(url: url)
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
    
    //size Product
    func getAllSize(completion: @escaping((AllSize?) -> Void), onError: @escaping(String) -> Void) {
            guard let url = URL(string: Endpoints.Gets.size.url) else {return}
            var request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                guard let httpRespon = response as? HTTPURLResponse else { return}
                guard let data = data else { return }

                if httpRespon.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(AllSize.self, from: data)
                        completion(result)
                    } catch {
                        print(error)
                    }
                } else {
                    guard let getFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else { return }
                    onError(getFailed.description)
                }
            }
            task.resume()
        }
}
