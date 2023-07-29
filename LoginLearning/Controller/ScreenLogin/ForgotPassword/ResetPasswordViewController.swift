//
//  ResetPasswordViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordText: UITextField! {
        didSet {
            passwordText.addShadow(color: .gray, width: 0.5, text: passwordText)
            passwordText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var confirmPassText: UITextField! {
        didSet {
            confirmPassText.addShadow(color: .gray, width: 0.5, text: confirmPassText)
            confirmPassText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetActionBtn(_ sender: UIButton) {
        guard let pass1 = passwordText.text else { return }
        guard let pass2 = confirmPassText.text else { return }
        
        if passwordText == nil && confirmPassText == nil {
            if  pass1 != pass2 {
                self.present(Alert.createAlertController(title: "Warning", message: "Password tidak sama dengan confirm Password"),animated: true)
            }
            self.present(Alert.createAlertController(title: "Warning", message: "Password tidak sama dengan confirm Password"),animated: true)
        } else {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
    }
    


}
