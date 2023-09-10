//
//  ChangePasswordViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 01/09/2566 BE.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    let viewModel = ChangePasswordVM()

    @IBOutlet weak var loadingView: UIActivityIndicatorView! {
        didSet {
            loadingView.isHidden = true
        }
    }
    @IBOutlet weak var inputConfirmPass: UITextField! {
        didSet {
            inputConfirmPass.addShadow(color: .gray, width: 0.5, text: inputConfirmPass)
            inputConfirmPass.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var inputNewPass: UITextField! {
        didSet {
            inputNewPass.addShadow(color: .gray, width: 0.5, text: inputNewPass)
            inputNewPass.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var inputOldPass: UITextField! {
        didSet {
            inputOldPass.addShadow(color: .gray, width: 0.5, text: inputOldPass)
            inputOldPass.isSecureTextEntry = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loadingStop() {
        self.loadingView.stopAnimating()
        self.loadingView.hidesWhenStopped = true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePassAction(_ sender: UIButton) {
        if !inputOldPass.hasText {
            SnackBarWarning.make(in: self.view, message:"Old Password is Empty", duration: .lengthShort).show()
            return
        }
        
        if !inputNewPass.hasText {
            SnackBarWarning.make(in: self.view, message:"New Password is Empty", duration: .lengthShort).show()
            return
        }
        
        if !inputConfirmPass.hasText {
            SnackBarWarning.make(in: self.view, message:"Confirm Password is Empty", duration: .lengthShort).show()
            return
        }
        
        guard let oldPass = inputOldPass.text else {return}
        guard let newPass = inputNewPass.text else {return}
        guard let confirmPass = inputConfirmPass.text else {return}
        
        if newPass != confirmPass {
            SnackBarWarning.make(in: self.view, message:"Password confirmation does not match", duration: .lengthShort).show()
            return
        }
        
        loadingView.isHidden = false
        loadingView.startAnimating()
        
        viewModel.postChangePass(oldPass: oldPass, newPass: newPass) { result in
            DispatchQueue.main.async {
                self.loadingStop()
                let alert = UIAlertController(title: "Success", message: result, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } onError: { error in
            DispatchQueue.main.async {
                self.loadingStop()
                SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
            }
        }

        
    }
    
}
