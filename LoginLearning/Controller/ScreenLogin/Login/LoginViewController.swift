//
//  LoginViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit
import SnackBar_swift

class LoginViewController: UIViewController {
    private let loginVM = LoginViewModel()
    
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
    
    @objc func securityPass() {
        if eyePass.currentImage == UIImage(systemName: "eye") {
            eyePass.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordText.isSecureTextEntry = false
        } else {
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordText.isSecureTextEntry = true
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
        
        @IBAction func backActionBtn(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
        
    @IBAction func loginActionBtn(_ sender: UIButton) {
        guard let userName = userNameText.text else { return }
        guard let pass = passwordText.text else { return }
        if userNameText != nil && passwordText != nil {
            loginVM.postLogin(userName: userName, password: pass) { response in
                DispatchQueue.main.async {
                    guard let token = response?.access_token else { return }
                    KeychainManager.shared.saveToken(token: token)
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    //
                }
            } onError: { error in
                DispatchQueue.main.async {
                    let refreshAlert = UIAlertController(title: "Failed Login", message: "\(error), Send Again Verification Account", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction!) in
                        let sendEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "SendEmailViewController") as! SendEmailViewController
                        self.navigationController?.pushViewController(sendEmailVC, animated: true)
                    }))
                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        refreshAlert .dismiss(animated: true, completion: nil)
                    }))

                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }

        }
      
    }
    
    
}
