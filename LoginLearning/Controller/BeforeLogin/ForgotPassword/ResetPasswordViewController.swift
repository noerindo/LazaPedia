//
//  ResetPasswordViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    private var viewModel: ResetPasswordVM!
   
    @IBOutlet weak var loadngView: UIActivityIndicatorView! {
        didSet {
            loadngView.isHidden = true
        }
    }
    
    @IBOutlet weak var eyeConfirm: UIButton! {
        didSet {
            eyeConfirm.setImage(UIImage(systemName: "eye"), for: .normal)
            eyeConfirm.addTarget(self, action: #selector(secureConfirmPass), for: .touchUpInside)
            
        }
    }
    @IBOutlet weak var eyePass: UIButton! {
        didSet {
            
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            eyePass.addTarget(self, action: #selector(securePass), for: .touchUpInside)
            
        }
    }
    @IBOutlet weak var passwordText: UITextField! {
        didSet {
            passwordText.isSecureTextEntry = true
            passwordText.addShadow(color: .gray, width: 0.5, text: passwordText)
            passwordText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var confirmPassText: UITextField! {
        didSet {
            confirmPassText.isSecureTextEntry = true
            confirmPassText.addShadow(color: .gray, width: 0.5, text: confirmPassText)
            confirmPassText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(code: String, email: String) {
        viewModel = ResetPasswordVM(codeEmail: code, email: email)
    }
    
    func loadingStop() {
        self.loadngView.stopAnimating()
        self.loadngView.hidesWhenStopped = true
    }
    
    @objc func securePass() {
        if eyePass.currentImage == UIImage(systemName: "eye") {
            eyePass.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordText.isSecureTextEntry = false
        } else {
            eyePass.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordText.isSecureTextEntry = true
        }
    }
    @objc func secureConfirmPass() {
        if eyeConfirm.currentImage == UIImage(systemName: "eye") {
            eyeConfirm.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            confirmPassText.isSecureTextEntry = false
        } else {
            eyeConfirm.setImage(UIImage(systemName: "eye"), for: .normal)
           confirmPassText.isSecureTextEntry = true
        }
    }
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func resetActionBtn(_ sender: UIButton) {
        guard let pass = passwordText.text else { return }
        guard let confirmPass = confirmPassText.text else { return }
        loadngView.isHidden = false
        loadngView.startAnimating()
        
        if !passwordText.hasText {
            self.loadingStop()
            SnackBarWarning.make(in: self.view, message: "Password cannot be empty", duration: .lengthShort).show()
            return
        }
        
        if !AcountRegis.invalidPassword(pass: pass) {
            self.loadingStop()
            SnackBarWarning.make(in: self.view, message: "Password min 8 characters, 1 letter, 1 number, & 1 special character.", duration: .lengthShort).show()
            return
        }
        
        if pass != confirmPass {
            self.loadingStop()
            SnackBarWarning.make(in: self.view, message: "password and confirm password are not the same", duration: .lengthShort).show()
            return
        }
        
        viewModel.resetPass(newPass: pass) { result in
            DispatchQueue.main.async {
                self.loadingStop()
                let alert = UIAlertController(title: "Success", message: result, preferredStyle: .alert)
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
            self.loadingStop()
            DispatchQueue.main.async {
                SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
            }
        }
    }
}
