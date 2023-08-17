//
//  AddAdressViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class AddAdressViewController: UIViewController {

    @IBOutlet weak var adressText: UITextField! {
        didSet {
            adressText.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var phoneText: UITextField!{
        didSet {
            phoneText.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var cityText: UITextField! {
        didSet {
            cityText.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var countryText: UITextField! {
        didSet {
            countryText.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var nameText: UITextField! {
        didSet {
            nameText.layer.cornerRadius = 5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
