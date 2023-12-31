//
//  LoginViewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 29/07/2566 BE.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Swifter
import GoogleSignIn

class LoginViewModel {
    
//    //Login SosialMedia
//    var swifter: Swifter!
//    var accToken: Credential.OAuthAccessToken?
//    var googleSignIn = GIDSignIn.sharedInstance
//    // fb
//    func loginBtnFb(sosmedVC: UIViewController) {
//        let loginfbManager = LoginManager()
//        loginfbManager.logIn(permissions: ["public_profile", "email"], from: sosmedVC , handler: { result, error in
//                  if error != nil {
//                      print("ERROR: Trying to get login results")
//                  } else if result?.isCancelled != nil {
//                      print("The token is \(result?.token?.tokenString ?? "")")
//                          if result?.token?.tokenString != nil {
//                          print("Logged in")
//                      } else {
//                          print("Cancelled")
//                      }
//                  }
//              })
//    }
//
//    // twiter
//    func loginBtnTwitter(sosmedVC: UIViewController) {
//        self.swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY)
//               self.swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: sosmedVC, success: { accessToken, _ in
//                   self.accToken = accessToken
////                   self.getUserProfile()
//               }, failure: { _ in
//                   print("ERROR: Trying to authorize")
//               })
//    }
//
//    func loginBtnGoggle(sosmedVC: UIViewController) {
//        GIDSignIn.sharedInstance.signIn(
//          withPresenting: sosmedVC) { signInResult, error in
//            guard let result = signInResult else {
//              // Inspect error
//              return
//            }
//            print("Username: ",signInResult?.user.profile?.name)
//          }
//
//    }
    
    
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
                KeychainManager.shared.saveRefreshToken(token: result.data.refresh_token)
                KeychainManager.shared.saveToken(token: result.data.access_token)
                print(result)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
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

