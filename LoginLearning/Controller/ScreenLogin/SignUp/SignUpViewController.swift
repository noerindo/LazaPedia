//
//  SignUpViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit
import SnackBar_swift

class SignUpViewController: UIViewController {
    var isCheck: Bool = false
    private let userViewModel = UserViewModel()
    
    @IBOutlet weak var checkUserName: UIImageView!
    
    @IBOutlet weak var strongPass: UILabel!
    @IBOutlet weak var checkEmail: UIImageView!
    @IBOutlet weak var eyePass: UIButton! {
        didSet {
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            eyePass.addTarget(self, action: #selector(securityConfir), for: .touchUpInside)
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
    
    @IBOutlet weak var emailText: UITextField! {
        didSet {
            emailText.addShadow(color: .gray, width: 0.5, text: emailText)
            emailText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var confirPassText: UITextField! {
        didSet {
            confirPassText.addShadow(color: .gray, width: 0.5, text: confirPassText)
            confirPassText.font = UIFont(name: "Inter-Medium", size: 15)
            confirPassText.isSecureTextEntry = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmail.isHidden = true
        checkUserName.isHidden = true
        strongPass.isHidden = true

    }
    @objc func securityConfir() {
        if isCheck {
            isCheck = false
            eyePass.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            confirPassText.isSecureTextEntry = false
            passwordText.isSecureTextEntry = false
        } else {
            isCheck = true
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            confirPassText.isSecureTextEntry = true
            passwordText.isSecureTextEntry = true
        }
    }
    
    @IBAction func checkPass(_ sender: UITextField) {
        guard let pass = passwordText.text else { return }
        if AcountRegis.invalidPassword(pass: pass) {
            strongPass.isHidden = false
        } else {
            strongPass.isHidden = true
        }
    }
    @IBAction func checkEmail(_ sender: UITextField) {
        guard let email = emailText.text else { return }
        if AcountRegis.invalidEmail(email: email) {
            checkEmail.isHidden = false
        } else {
            checkEmail.isHidden = true
        }
    }
    @IBAction func checkUserName(_ sender: UITextField) {
        guard let username = userNameText.text else { return }
        if AcountRegis.invalidUserNAme(userName: username) {
            checkUserName.isHidden = false
        } else {
            checkUserName.isHidden = true
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        guard let userName = userNameText.text else { return }
        guard let email = emailText.text else { return }
        guard let pass = passwordText.text else { return }
        guard let confirPass = confirPassText.text else { return }
        
        if AcountRegis.invalidUserNAme(userName: userName) {
            if AcountRegis.invalidEmail(email: email) {
                if AcountRegis.invalidPassword(pass: pass) {
                    if pass == confirPass {
                        APICall().postRegister(email: email, userName: userName, password: pass) { response in
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Registration Success", message: "Check email for confirm account", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                                  DispatchQueue.main.async {
                                      let loginVC = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                      self?.navigationController?.pushViewController(loginVC, animated: true)
                                  }
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        } onError: { error in
                            DispatchQueue.main.async {
                                SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                            }
                        }

                    } else {
                        SnackBarWarning.make(in: self.view, message: "password and confirm password are not the same", duration: .lengthShort).show()
                    }

                } else {
                    SnackBarWarning.make(in: self.view, message: "Password min 8 characters, 1 letter, 1 number, & 1 special character.", duration: .lengthShort).show()
                }
            } else {
                SnackBarWarning.make(in: self.view, message: "Email is not valid.", duration: .lengthShort).show()
            }
        } else {
            SnackBarWarning.make(in: self.view, message: "UserName mn 8 characters", duration: .lengthShort).show()
        }
    }
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

