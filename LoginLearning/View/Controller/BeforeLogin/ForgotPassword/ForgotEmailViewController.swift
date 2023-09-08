//
//  ForgotEmailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit

class ForgotEmailViewController: UIViewController {
    private let modelView = ForgotEmailVM()

    @IBOutlet weak var emailText: UITextField! {
        didSet {
            emailText.addShadow(color: .gray, width: 0.5, text: emailText)
            emailText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmActionBtn(_ sender: UIButton) {
        guard let email = emailText.text else { return }
        if AcountRegis.invalidEmail(email: email) {
            modelView.postForgetPass(email: email) { response in
                DispatchQueue.main.async {
                    if response == "successfully send mail forgot password" {
                        let alert = UIAlertController(title: "Success", message: response, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                          DispatchQueue.main.async {
                              let kodeVC = self?.storyboard?.instantiateViewController(withIdentifier: "KodePassViewController") as! KodePassViewController
                              kodeVC.configure(email: email)
                              self?.navigationController?.pushViewController(kodeVC, animated: true)
                          }
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        SnackBarWarning.make(in: self.view, message: response, duration: .lengthShort).show()
                    }
                }
            } onError: { error in
                DispatchQueue.main.async {
                    SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                }
            }
        } else {
            SnackBarWarning.make(in: self.view, message: "Email is not valid.", duration: .lengthShort).show()
        }
    }
    
    @IBAction func backactionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
