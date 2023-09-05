//
//  ViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isLogin") == true {
            navigationController?.setNavigationBarHidden(true, animated: true)
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            self.navigationController?.pushViewController(homeVC, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}

//    @IBOutlet weak var bottomView: UIView! {
//        didSet {
//            bottomView.layer.cornerRadius = 20
//        }
//    }
//   ////
//    @IBOutlet weak var TitleLabel: UILabel!{
//        didSet {
//            TitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
//        }
//    }
//
//    @IBOutlet weak var descLabel: UILabel!{
//        didSet {
//            descLabel.font = UIFont(name: "Inter-Regular", size: 15)
//        }
//    }
//
//    @IBOutlet weak var menBtn: UIButton! {
//        didSet {
//            menBtn.titleLabel?.font = UIFont(name: "Inter-Medium", size: 17)
//            menBtn.layer.cornerRadius = 5
//        }
//    }
//
//    @IBOutlet weak var womenBtn: UIButton! {
//        didSet {
//            womenBtn.titleLabel?.font = UIFont(name: "Inter-Medium", size: 17)
//            womenBtn.layer.cornerRadius = 5
//        }
//    }
//
//    @IBOutlet weak var skipBtn: UIButton! {
//        didSet {
//            skipBtn.titleLabel?.font = UIFont(name: "Inter-Medium", size: 17)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if UserDefaults.standard.bool(forKey: "UseriIsLogin") == true {
//            let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//            self.navigationController?.pushViewController(tabVC, animated: true)
//        }
//
//    }
//
//    @IBAction func menActionBtn(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//
//        if sender.isSelected {
//            sender.setTitleColor(.gray, for: .selected)
//            sender.backgroundColor = UIColor(named: "colorBtn")
//        } else {
//            sender.setTitleColor(.white, for: .selected)
//            sender.backgroundColor = UIColor(named: "colorBg")
//        }
//        moveLogin()
//    }
//
//    @IBAction func womenActionBtn(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//
//        if sender.isSelected {
//            sender.setTitleColor(.gray, for: .selected)
//            sender.backgroundColor = UIColor(named: "colorBtn")
//        } else {
//            sender.setTitleColor(.white, for: .selected)
//            sender.backgroundColor = UIColor(named: "colorBg")
//        }
//        moveLogin()
//
//    }
//
//    @IBAction func skipActionBtn(_ sender: UIButton) {
//        moveLogin()
//    }
//
//    private func moveLogin() {
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        let loginSosmedVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginSosmedViewController") as! LoginSosmedViewController
//        self.navigationController?.pushViewController(loginSosmedVC, animated: true)
//    }
//}

