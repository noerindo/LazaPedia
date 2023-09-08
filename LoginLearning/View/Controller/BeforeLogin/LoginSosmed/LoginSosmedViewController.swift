//
//  LoginSosmedViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit


class LoginSosmedViewController: UIViewController {
//    private let loginVM = LoginViewModel()
    
    @IBOutlet weak var fbBtn: UIButton! {
        didSet {
            fbBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var twitterBtn: UIButton! {
        didSet {
            twitterBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var googleBtn: UIButton! {
        didSet {
            googleBtn.layer.cornerRadius = 10
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func googleActionBtn(_ sender: UIButton) {
//        loginVM.loginBtnGoggle(sosmedVC: self)
    }
    @IBAction func fbActionBtn(_ sender: UIButton) {
//        loginVM.loginBtnFb(sosmedVC: self)
    }
    
    @IBAction func twitterActionBtn(_ sender: UIButton) {
//        loginVM.loginBtnTwitter(sosmedVC: self)
    }
    
    @IBAction func signInActionBtn(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)

    }
    
    @IBAction func creatActBtn(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
