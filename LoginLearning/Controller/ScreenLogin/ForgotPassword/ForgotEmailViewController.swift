//
//  ForgotEmailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit

class ForgotEmailViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField! {
        didSet {
            emailText.addShadow(color: .gray, width: 0.5, text: emailText)
            emailText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmActionBtn(_ sender: UIButton) {
        guard let emailTxt = emailText.text else { return }
            APICall().fetchAPIUser { UserIndex in
                let matchingEmail = UserIndex.first { user in
                    user.email == emailTxt &&  self.emailText != nil
                }
                if let isEmail = matchingEmail {
                    DispatchQueue.main.async {
                        let resetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        self.navigationController?.pushViewController(resetVC, animated: true)
                    }
                } else {
                    self.present(Alert.createAlertController(title: "Warning", message: "Email tidak terdetec"),animated: true)
                }
            }
        
        
    }
    
    @IBAction func backactionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
