//
//  LoginSosmedViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Swifter
import SafariServices
import GoogleSignIn

class LoginSosmedViewController: UIViewController,SFSafariViewControllerDelegate {
    
    let getUserSosmed = GetUserProfile()
    
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?
    var googleSignIn = GIDSignIn.sharedInstance
    
    @IBOutlet weak var fbBtn: UIButton! {
        didSet {
            fbBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var twitterBtn: UIButton! {
        didSet {
            twitterBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var googleBtn: UIButton! {
        didSet {
            googleBtn.layer.cornerRadius = 10
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    @IBAction func googleActionBtn(_ sender: UIButton) {
        self.loginBtnGoggle()
    }
    @IBAction func fbActionBtn(_ sender: UIButton) {
        self.loginBtnFb()
    }
    
    @IBAction func twitterActionBtn(_ sender: UIButton) {
        self.loginBtnTwitter()
    }
    
    
    // fb
    func loginBtnFb() {
        let loginfbManager = LoginManager()
        loginfbManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
                  if error != nil {
                      print("ERROR: Trying to get login results")
                  } else if result?.isCancelled != nil {
                      print("The token is \(result?.token?.tokenString ?? "")")
                      if result?.token?.tokenString != nil {
                          print("Logged in")
//                          self.getUserSosmed.getUserProfileFb(token: result?.token, userId: result?.token?.userID)
//                          self.getUserProfileFb(token: result?.token, userId: result?.token?.userID)
                      } else {
                          print("Cancelled")
                      }
                  }
              })
    }
    
    // twiter
    func loginBtnTwitter() {
        self.swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY)
               self.swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self, success: { accessToken, _ in
                   self.accToken = accessToken
//                   self.getUserProfile()
               }, failure: { _ in
                   print("ERROR: Trying to authorize")
               })
    }
    
    func loginBtnGoggle() {
        if let urlGoogle = URL(string: "https://accounts.google.com/InteractiveLogin/signinchooser?"){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let googleVC = SFSafariViewController(url: urlGoogle, configuration: config)
            present(googleVC, animated: true)
        }
        
//        let googleConfig = GIDConfiguration(clientID: "CLIENT_ID")
//            self.googleSignIn.signIn(with: googleConfig, presenting: self) { user, error in
//                if error == nil {
//                    guard let user = user else {
//                        print("Uh oh. The user cancelled the Google login.")
//                        return
//                    }
//
//                    let userId = user.userID ?? ""
//                    print("Google User ID: \(userId)")
//
//                    let userIdToken = user.authentication.idToken ?? ""
//                    print("Google ID Token: \(userIdToken)")
//
//                    let userFirstName = user.profile?.givenName ?? ""
//                    print("Google User First Name: \(userFirstName)")
//
//                    let userLastName = user.profile?.familyName ?? ""
//                    print("Google User Last Name: \(userLastName)")
//
//                    let userEmail = user.profile?.email ?? ""
//                    print("Google User Email: \(userEmail)")
//
//                    let googleProfilePicURL = user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""
//                    print("Google Profile Avatar URL: \(googleProfilePicURL)")
//
//                }
//            }
    }

    func getUserProfile() {
            self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
                // ...Getting Profile Data
                // Save the Access Token (accToken.key) and Access Token Secret (accToken.secret) using UserDefaults
                // This will allow us to check user's logging state every time they open the app after cold start.
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.accToken?.key, forKey: "oauth_token")
                userDefaults.set(self.accToken?.secret, forKey: "oauth_token_secret")
            }) { error in
                print("ERROR: \(error.localizedDescription)")
            }
        }
    
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signInActionBtn(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)

    }
    
    @IBAction func creatActBtn(_ sender: UIButton) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
