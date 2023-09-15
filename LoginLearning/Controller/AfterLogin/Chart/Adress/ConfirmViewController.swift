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

    }
    

     @IBAction func continueShop(_ sender: UIButton) {
         let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
         self.navigationController?.pushViewController(homeVC, animated: true)
     }
}
