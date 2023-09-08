//
//  SendEmailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import UIKit

class SendEmailViewController: UIViewController {
    private let viewModel = SendEmailVM()
    @IBOutlet weak var loadingView: UIActivityIndicatorView! {
        didSet {
            loadingView.isHidden = true
        }
    }
    @IBOutlet weak var emailTextInput: UITextField! {
    didSet {
        emailTextInput.addShadow(color: .gray, width: 0.5, text: emailTextInput)
        emailTextInput.font = UIFont(name: "Inter-Medium", size: 15)
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
    
    @IBAction func sendActionBtn(_ sender: UIButton) {
        loadingView.isHidden = false
        loadingView.startAnimating()
        guard let email = emailTextInput.text else {return}
        
        if AcountRegis.invalidEmail(email: email) {
            viewModel.postVerifikasiAccount(email: email) { result in
                DispatchQueue.main.async {
                    self.loadingStop()
                    let refreshAlert = UIAlertController(title: "Succes", message: result, preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }))

                    self.present(refreshAlert, animated: true, completion: nil)
                }
            } onError: { error in
                self.loadingStop()
                SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
            }

        } else {
            self.loadingStop()
            SnackBarWarning.make(in: self.view, message: "Email is not valid.", duration: .lengthShort).show()
        }
        
    }
    
}
