//
//  LoginViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit
import SnackBar_swift

class LoginViewController: UIViewController {
    private let networkAPI = NetworkAPI()
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView! {
        didSet {
            loadingView.isHidden = true
        }
    }
    
    @IBOutlet weak var eyePass: UIButton! {
        didSet {
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            eyePass.addTarget(self, action: #selector(securityPass), for: .touchUpInside)
        }
    }
    @IBOutlet weak var checkUserName: UIImageView! {
        didSet {
            checkUserName.isHidden = true
        }
    }
    @IBOutlet weak var userNameText: UITextField! {
        didSet {
            userNameText.addShadow(color: .gray, width: 0.5, text: userNameText)
            userNameText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var switchRemember: UISwitch!
    
    @IBOutlet weak var passwordText: UITextField! {
        didSet {
            passwordText.addShadow(color: .gray, width: 0.5, text: passwordText)
            passwordText.font = UIFont(name: "Inter-Medium", size: 15)
            passwordText.isSecureTextEntry = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadingStop() {
        loadingView.stopAnimating()
        loadingView.hidesWhenStopped = true
    }
    @objc func securityPass() {
        if eyePass.currentImage == UIImage(systemName: "eye") {
            eyePass.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordText.isSecureTextEntry = false
        } else {
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordText.isSecureTextEntry = true
        }
    }
    
    @IBAction func switchRemember(_ sender: UISwitch) {
        if switchRemember.isOn {
            self.userNameText.text = UserDefaults.standard.string(forKey: "UserName")
        } else {
            self.userNameText.text = ""
        }
    }
    
    @IBAction func checkFieldUserName(_ sender: UITextField) {
        guard let username = userNameText.text else { return }
        if AcountRegis.invalidUserNAme(userName: username) {
            checkUserName.isHidden = false
        } else {
            checkUserName.isHidden = true
        }
    }
    
    @IBAction func fogitBtn(_ sender: UIButton) {

        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotEmailViewController") as! ForgotEmailViewController
        self.navigationController?.pushViewController(forgotVC , animated: true)
        }
        
        
    @IBAction func signUpBtn(_ sender: UIButton) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func loginActionBtn(_ sender: UIButton) {
        loadingView.isHidden = false
        loadingView.startAnimating()
        guard let userName = userNameText.text else { return }
        guard let pass = passwordText.text else { return }
        
        if !userNameText.hasText {
            SnackBarWarning.make(in: self.view, message:"UserName is Empty", duration: .lengthShort).show()
            return
        }
        
        if !passwordText.hasText {
            SnackBarWarning.make(in: self.view, message:"Password is Empty", duration: .lengthShort).show()
            return
        }
        
        networkAPI.postLogin(userName: userName, password: pass) { [self] response in
                print("Hallo")
                networkAPI.getProfile(token: response!.access_token) { result in
                    guard let userProfile = result else { return }
                    KeychainManager.shared.saveRefreshToken(token: response!.refresh_token)
                    KeychainManager.shared.saveToken(token: response!.access_token)
                    
                    KeychainManager.shared.saveProfileToKeychain(profile: userProfile)
                    DispatchQueue.main.async {
                        self.loadingStop()
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                } onError: { error in
                    SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                }
            } onError: { error in
                DispatchQueue.main.async {
                    self.loadingStop()
                    if error == "please verify your account" {
                        let refreshAlert = UIAlertController(title: "Failed Login", message: "\(error), Send Again Verification Account", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction!) in
                            let sendEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "SendEmailViewController") as! SendEmailViewController
                            self.navigationController?.pushViewController(sendEmailVC, animated: true)
                        }))
                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                            refreshAlert .dismiss(animated: true, completion: nil)
                        }))

                        self.present(refreshAlert, animated: true, completion: nil)
                    } else {
                        self.loadingStop()
                        SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                    }
                    
                }
            }
      
    }
    
}

//SnapKit
