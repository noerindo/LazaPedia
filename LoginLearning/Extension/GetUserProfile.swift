//
//  GetUserProfile.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 27/07/2566 BE.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Swifter

class GetUserProfile {
    
    func getUserProfileFb(token: AccessToken?, userId: String?) {
            let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
            graphRequest.start { _, result, error in
                if error == nil {
                    let data: [String: AnyObject] = result as! [String: AnyObject]
                    
                    // Facebook Id
                    if let facebookId = data["id"] as? String {
                        print("Facebook Id: \(facebookId)")
                    } else {
                        print("Facebook Id: Not exists")
                    }
                    
                    // Facebook First Name
                    if let facebookFirstName = data["first_name"] as? String {
                        print("Facebook First Name: \(facebookFirstName)")
                    } else {
                        print("Facebook First Name: Not exists")
                    }
                    
                    // Facebook Middle Name
                    if let facebookMiddleName = data["middle_name"] as? String {
                        print("Facebook Middle Name: \(facebookMiddleName)")
                    } else {
                        print("Facebook Middle Name: Not exists")
                    }
                    
                    // Facebook Last Name
                    if let facebookLastName = data["last_name"] as? String {
                        print("Facebook Last Name: \(facebookLastName)")
                    } else {
                        print("Facebook Last Name: Not exists")
                    }
                    
                    // Facebook Name
                    if let facebookName = data["name"] as? String {
                        print("Facebook Name: \(facebookName)")
                    } else {
                        print("Facebook Name: Not exists")
                    }
                    
                    // Facebook Profile Pic URL
                    let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                    print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                    
                    // Facebook Email
                    if let facebookEmail = data["email"] as? String {
                        print("Facebook Email: \(facebookEmail)")
                    } else {
                        print("Facebook Email: Not exists")
                    }
                    
                    print("Facebook Access Token: \(token?.tokenString ?? "")")
                } else {
                    print("Error: Trying to get user's info")
                }
            }
        }
    
//    func getUserProfileTwitter() {
//            self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
//                // Twitter Id
//                if let twitterId = json["id_str"].string {
//                    print("Twitter Id: \(twitterId)")
//                } else {
//                    self.twitterId = "Not exists"
//                }
//                // Twitter Handle
//                if let twitterHandle = json["screen_name"].string {
//                    print("Twitter Handle: \(twitterHandle)")
//                } else {
//                    self.twitterHandle = "Not exists"
//                }
//                // Twitter Name
//                if let twitterName = json["name"].string {
//                    print("Twitter Name: \(twitterName)")
//                } else {
//                    self.twitterName = "Not exists"
//                }
//                // Twitter Email
//                if let twitterEmail = json["email"].string {
//                    print("Twitter Email: \(twitterEmail)")
//                } else {
//                    self.twitterEmail = "Not exists"
//                }
//                // Twitter Profile Pic URL
//                if let twitterProfilePic = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) {
//                    print("Twitter Profile URL: \(twitterProfilePic)")
//                } else {
//                    self.twitterProfilePicURL = "Not exists"
//                }
//                print("Twitter Access Token: \(self.accToken?.key ?? "Not exists")")
//            }) { error in
//                print("ERROR: \(error.localizedDescription)")
//            }
//        }
}
