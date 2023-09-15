//
//  AddAdressViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class AddAdressViewController: UIViewController {
    var viewModel = AddAdressViewVM()
    var isUpdate: Bool = false

    @IBOutlet weak var titleVC: UILabel!
    @IBOutlet weak var switchPrimary: UISwitch!
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
        if isUpdate == true {
            self.configureViewUpdate()
        }
    }
    
    func configureUpdate(data: DataAdress) {
        viewModel.selectedData = data
    }
    
    func configureViewUpdate() {
        guard let dataUpdate = viewModel.selectedData else {return}
        
        titleVC.text = "Update Address"
        nameText.text = "\(dataUpdate.receiver_name)"
        phoneText.text = "\(dataUpdate.phone_number)"
        countryText.text = "\(dataUpdate.country)"
        cityText.text = "\(dataUpdate.city)"
        switchPrimary.isOn = dataUpdate.is_primary ?? false
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAdressAction(_ sender: UIButton) {
        if !nameText.hasText {
            SnackBarWarning.make(in: self.view, message:"Name is Empty", duration: .lengthShort).show()
            return
        }
        if !countryText.hasText {
            SnackBarWarning.make(in: self.view, message:"Country is Empty", duration: .lengthShort).show()
            return
        }
        if !cityText.hasText {
            SnackBarWarning.make(in: self.view, message:"City is Empty", duration: .lengthShort).show()
            return
        }
        if !phoneText.hasText {
            SnackBarWarning.make(in: self.view, message:"Phone number is Empty", duration: .lengthShort).show()
            return
        }
        
        guard let name = nameText.text else {return}
        guard let country = countryText.text else {return}
        guard let city = cityText.text else {return}
        guard let phone = phoneText.text else {return}
        let isPrimary = switchPrimary.isOn
        
        if AcountRegis.invalidNoHp(noHp: phone) {
            if isUpdate == true {
                guard let idUpdate = viewModel.selectedData?.id else {return}
                viewModel.networkAPI.putAdress(id: idUpdate, country: country, city: city, receiver_name: name, phone_number: phone, is_primary: isPrimary) { result in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: "Add Adress Success", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                            AdressViewController.notifyObserver()
                            DispatchQueue.main.async {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } onError: { error in
                    SnackBarWarning.make(in: self.view, message:error, duration: .lengthShort).show()
                }
            } else {
                viewModel.networkAPI.postAdress(country: country, city: city, receiver_name: name, phone_number: phone, is_primary: isPrimary) { result in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: "Add Adress Success", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                            AdressViewController.notifyObserver()
                            DispatchQueue.main.async {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } onError: { error in
                    SnackBarWarning.make(in: self.view, message:error, duration: .lengthShort).show()
                }

            }
        } else {
            SnackBarWarning.make(in: self.view, message: "Number HP is not valid", duration: .lengthShort).show()
        }

        
    }
}
