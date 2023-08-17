//
//  AdressViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit


protocol BtnBackDelegate: AnyObject {
    func backOrderUp()
}

class AdressViewController: UIViewController {

    @IBOutlet weak var textEmpty: UIButton!
    let adressModel = AdressUser()
    @IBOutlet weak var tableAdress: UITableView!
    weak var delegate: BtnBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdress.dataSource = self
        tableAdress.delegate = self
        tableAdress.register(UINib(nibName: "AdressTableViewCell", bundle: nil), forCellReuseIdentifier: "AdressTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backOrderUp()
    }
    
    @IBAction func addAdressBtn(_ sender: UIButton) {
        let addAdresVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
        self.navigationController?.pushViewController(addAdresVC, animated: true)
    }
}
extension AdressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if adressModel.count == 0 {
            textEmpty.isHidden = false
        } else {
            textEmpty.isHidden = true
        }
        return adressModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableAdress.dequeueReusableCell(withIdentifier: "AdressTableViewCell", for: indexPath) as? AdressTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
    
    
}
