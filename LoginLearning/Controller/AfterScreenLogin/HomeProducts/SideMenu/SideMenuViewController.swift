//
//  SideMenuViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import SideMenu

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    var profileMV = ProfileModelView()
    
    @IBOutlet weak var orderText: UILabel! {
        didSet {
            orderText.layer.cornerRadius = 20
        }
    }
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?
    
    @IBOutlet weak var photoAcount: UIImageView! {
        didSet {
            photoAcount.layer.cornerRadius = photoAcount.frame.size.width / 2
            photoAcount.clipsToBounds = true
        }
    }
    @IBOutlet weak var orderView: UILabel! {
        didSet {
            orderView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var tableSide: UITableView!
    @IBOutlet weak var ketControlMode: UILabel!
    @IBOutlet weak var controlMode: UISwitch!
    @IBOutlet weak var nameAcount: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var sideOnBtn: UIButton!
    {
        didSet {
                let size = CGSize(width: 20, height: 20)
                let rect = CGRect(origin: .zero, size: size)
                var image = UIImage(named: "sideOn")
                UIGraphicsBeginImageContextWithOptions(size, false, 1)
                image?.draw(in: rect)
                image = UIGraphicsGetImageFromCurrentImageContext()
                sideOnBtn.setImage(image, for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataProfile()
        tableSide.dataSource = self
        tableSide.delegate = self
        tableSide.register(UINib(nibName: "SideTableViewCell", bundle: nil), forCellReuseIdentifier: "SideTableViewCell")
        
        DispatchQueue.main.async {
            _ = IndexPath(row: self.defaultHighlightedCell, section: 0)
        }
    }
    
    @IBAction func logOutActionBtn(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Warning", message: "you will exit the application", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("before",Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            let domain = Bundle.main.bundleIdentifier!
            print("domain=",domain)
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys))
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginSosmedViewController") as! LoginSosmedViewController
                self.navigationController?.pushViewController(tabVC, animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert .dismiss(animated: true, completion: nil)
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.windows.first
        if controlMode.isOn == true {
            appDelegate?.overrideUserInterfaceStyle = .dark
        }
        else {
            appDelegate?.overrideUserInterfaceStyle = .light
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func getDataProfile() {
        profileMV.getProfile {data in
            DispatchQueue.main.async { [self] in
                nameAcount.text = data?.full_name
                let imgURl = URL(string: "\(data?.image_url ?? "")")
                self.photoAcount.sd_setImage(with: imgURl)
            }
        } onError: { error in
            print(error)
        }

    }
}


extension SideMenuViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellSide.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell", for: indexPath) as? SideTableViewCell {
            let cellSideA = cellSide[indexPath.item]
            cell.configure(data: cellSideA)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            moveCellSide(index: 2)
        case 3:
            moveCellSide(index: 3)
        case 4:
            moveCellSide(index: 1)
        default:
            moveCellSide(index: 0)
        }
        
    }
    
}

extension SideMenuViewController {
    func moveCellSide(index: Int) {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
//        vc.selectedIndex = index
//        _ = vc.selectedViewController
//
//self.navigationController?.view.window?.windowScene?.keyWindow?.rootViewController = vc
        let sideMenuNav = self.navigationController as? SideMenuNavigationController
        sideMenuNav?.dismiss(animated: true)
        delegate?.selectedCell(index)
    }
}
