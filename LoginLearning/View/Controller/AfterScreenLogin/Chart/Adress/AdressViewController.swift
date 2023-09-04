//
//  AdressViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit


protocol BtnBackDelegate: AnyObject {
    func backOrderUp()
    func sendAdressOrder(country: String, city: String, isChoose: Bool)
}

class AdressViewController: UIViewController {

    @IBOutlet weak var textEmpty: UILabel! {
        didSet {
            textEmpty.isHidden = true
        }
    }
    let adressVM = AdressViewModel()
    @IBOutlet weak var tableAdress: UITableView!
    weak var delegate: BtnBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObserver()
        
        tableAdress.dataSource = self
        tableAdress.delegate = self
        tableAdress.register(UINib(nibName: "AdressTableViewCell", bundle: nil), forCellReuseIdentifier: "AdressTableViewCell")

        adressVM.loadAdress { result in
            DispatchQueue.main.async {
                self.tableAdress.reloadData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:Notification.Name.UpdateAdress, object: nil)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAdress), name: Notification.Name.UpdateAdress, object: nil)
    }
    
    static func notifyObserver() {
        NotificationCenter.default.post(name: Notification.Name.UpdateAdress, object: nil)
    }
    
    @objc private func reloadAdress() {
        adressVM.loadAdress { result in
            DispatchQueue.main.async {
                self.tableAdress.reloadData()
            }
        }
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
        if adressVM .adressCount == 0 {
            textEmpty.isHidden = false
        } else {
            textEmpty.isHidden = true
        }
        return adressVM .adressCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableAdress.dequeueReusableCell(withIdentifier: "AdressTableViewCell", for: indexPath) as? AdressTableViewCell{
            let dataCell = adressVM.resultAdress.data[indexPath.item]
            cell.configureAdress(data: dataCell)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = adressVM.resultAdress.data[indexPath.item]
        let deleteData = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
              DispatchQueue.main.async {
                  self?.adressVM.deleteAdress(id: data.id, completion: { respon in
                      DispatchQueue.main.async {
                          self?.adressVM.resultAdress.data.removeAll {$0.id == data.id}
                          self?.tableAdress.deleteRows(at: [indexPath], with: .left)
                      }
                  })
              }
            }
            deleteData.backgroundColor = .systemRed
        
        let updateData = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler)  in
              DispatchQueue.main.async {
                  let addAdresVC = self?.storyboard?.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
                  addAdresVC.idData = data.id
                  addAdresVC.adressData = data
                  self?.navigationController?.pushViewController(addAdresVC, animated: true)
              }
            }
        updateData.backgroundColor = .systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteData,updateData])
            return configuration
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var adress = adressVM.resultAdress.data[indexPath.item]
        delegate?.sendAdressOrder(country: adress.country, city: adress.city, isChoose: true)
        self.navigationController?.popViewController(animated: true)
        
        
    }
}
