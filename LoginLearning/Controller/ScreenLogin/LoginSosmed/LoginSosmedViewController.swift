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
import GoogleSignIn

class LoginSosmedViewController: UIViewController {
    
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
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }

            // If sign in succeeded, display the app's main content View.
          }
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
        
//        if let urlGoogle = URL(string: "https://accounts.google.com/InteractiveLogin/signinchooser?"){
//            let config = SFSafariViewController.Configuration()
//            config.entersReaderIfAvailable = true
//
//            let googleVC = SFSafariViewController(url: urlGoogle, configuration: config)
//            present(googleVC, animated: true)
//        }
    }

    func getUserProfile() {
            self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.accToken?.key, forKey: "oauth_token")
                userDefaults.set(self.accToken?.secret, forKey: "oauth_token_secret")
            }) { error in
                print("ERROR: \(error.localizedDescription)")
            }
        }
    
    @IBAction func signInActionBtn(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)

    }
    
    @IBAction func creatActBtn(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
