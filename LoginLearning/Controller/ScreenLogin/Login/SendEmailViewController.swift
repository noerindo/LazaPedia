//
//  SendEmailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import UIKit

class SendEmailViewController: UIViewController {

    @IBOutlet weak var emailTextInput: UITextField! {
    didSet {
        emailTextInput.addShadow(color: .gray, width: 0.5, text: emailTextInput)
        emailTextInput.font = UIFont(name: "Inter-Medium", size: 15)
    }
}
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func sendActionBtn(_ sender: UIButton) {
        
    }
    
}
