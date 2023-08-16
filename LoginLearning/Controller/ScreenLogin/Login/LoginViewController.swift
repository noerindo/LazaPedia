//
//  LoginViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit
import SnackBar_swift

class LoginViewController: UIViewController {
    private let userViewModel = UserViewModel()
    
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            APICall().postLogin(userName: userName, password: pass) { response in
                DispatchQueue.main.async {
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    //
                }
            } onError: { error in
                DispatchQueue.main.async {
                    SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                }
            }

        }
//            APICall().fetchAPIUser { UserIndex in
//                let matchingUser = UserIndex.first { user in
//                    user.username == userName && user.password == pass
//                }
//                if let isUser = matchingUser {
//                    DispatchQueue.main.async {
//                        self.userViewModel.loginDefault(isLogin: true, userName: userName, pass: pass)
//                        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//                        self.navigationController?.pushViewController(homeVC, animated: true)
//                        
//                    }
//                } else {
////                    self.present(Alert.createAlertController(title: "Warning", message: "periksa kembali username and password"),animated: true)
//                    
//                }
//                
//            }
//        } else {
////            self.present(Alert.createAlertController(title: "Warning", message: "data belum lengkap"),animated: true)
//        }
//        
      
    }
    
    
}
