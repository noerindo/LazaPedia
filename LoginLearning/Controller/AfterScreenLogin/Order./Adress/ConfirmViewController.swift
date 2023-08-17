//
//  ConfirmViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class ConfirmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goToactionBtn(_ sender: UIButton) {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
//        vc.selectedIndex = index
//        _ = vc.selectedViewController
//
//self.navigationController?.view.window?.windowScene?.keyWindow?.rootViewController = vc
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }

     @IBAction func continueShop(_ sender: UIButton) {
         let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
         self.navigationController?.pushViewController(homeVC, animated: true)
     }
}
