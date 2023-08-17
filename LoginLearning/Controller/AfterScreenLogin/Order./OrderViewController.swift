//
//  OrderViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class OrderViewController: UIViewController {
    lazy var bottomSheet = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderPopUpViewController")
    
    @IBOutlet weak var tableOrder: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarText()
        tableOrder.delegate = self
        tableOrder.dataSource = self
        tableOrder.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
    }
    
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Order"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        
        tabBarItem.selectedImage = UIImage(view: label2)
    }
    
    @IBAction func popUpActionBtn(_ sender: UIButton) {
        let tabVC = UINavigationController(rootViewController: bottomSheet)
        let vc = bottomSheet as? OrderPopUpViewController
        vc?.delegate = self
            if let sheet = tabVC.sheetPresentationController {
              sheet.detents = [.medium()]
            }
            self.present(tabVC, animated: true)
    }
    
}

extension OrderViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell {
            let cellList = orderList[indexPath.item]
            cell.configure(data: cellList)
            return cell
        }
        return UITableViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }
    
}

extension OrderViewController:BtnMoveIntoDelegate {
    func moveAdress() {
        print("move")
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdressViewController")
        //menghubungkan
        let adressVC = storyboard as? AdressViewController
        adressVC?.delegate = self
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func moveMethodPay() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MethodPayViewController")
        //menghubungkan
        let payMetdoVC = storyboard as? MethodPayViewController
        payMetdoVC?.delegate = self
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
}

extension OrderViewController: BtnBackDelegate {
    
    func orderPopactive() {
        let tabVC = UINavigationController(rootViewController: bottomSheet)
        let vc = bottomSheet as? OrderPopUpViewController
        vc?.delegate = self
            if let sheet = tabVC.sheetPresentationController {
              sheet.detents = [.medium()]
            }
            self.present(tabVC, animated: true)
    }
    func backBtnOrderPop() {
        orderPopactive()
    }
    
    func backOrderUp() {
        orderPopactive()
    }
    

}
