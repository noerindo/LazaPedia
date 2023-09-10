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
    func changePassword()
    func movePayment()
}

class SideMenuViewController: UIViewController {
    let viewModel =  ProfileVM()
    
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?
    var modelProfile : DataProfileUser?
    
    @IBOutlet weak var photoAcount: UIImageView! {
        didSet {
            photoAcount.layer.cornerRadius = photoAcount.frame.size.width / 2
            photoAcount.clipsToBounds = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDarkMode()
    }
    
    @IBAction func logOutActionBtn(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Warning", message: "you will exit the application", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                KeychainManager.shared.deleteResfreshToken()
                KeychainManager.shared.deleteToken()
                KeychainManager.shared.deleteProfileFromKeychain()
                
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.removeObject(forKey: "UserProfileDefault")
            }
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(tabVC, animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert .dismiss(animated: true, completion: nil)
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.setValue(true, forKey: "darkmode")
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.setValue(false, forKey: "darkmode")
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    func getDataProfile() {
        DispatchQueue.main.async { [self] in
            guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
            guard let imageString = dataUser.image_url else {
                self.photoAcount.image = UIImage(systemName: "person.circle.fill")
                return
            }
            
            nameAcount.text = dataUser.full_name
            let imgURL = URL(string: "\(imageString)")
            photoAcount.sd_setImage(with: imgURL)
        }
    }
    
    func checkDarkMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkmode")
        if isDarkMode {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
            controlMode.isOn = true
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
            }
            controlMode.isOn = false
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
        case 0:
            moveCellSide(index: 3)
        case 1:
            moveChangePass()
        case 2:
            moveCellSide(index: 2)
        case 3:
            movePayment()
        case 4:
            moveCellSide(index: 1)
        default:
            moveCellSide(index: 0)
        }
        
    }
    
}

extension SideMenuViewController {
    func moveChangePass() {
        let sideMenuNav = self.navigationController as? SideMenuNavigationController
        sideMenuNav?.dismiss(animated: true)
        delegate?.changePassword()
    }
    
    func movePayment() {
        let sideMenuNav = self.navigationController as? SideMenuNavigationController
        sideMenuNav?.dismiss(animated: true)
        delegate?.movePayment()
    }
    func moveCellSide(index: Int) {
        let sideMenuNav = self.navigationController as? SideMenuNavigationController
        sideMenuNav?.dismiss(animated: true)
        delegate?.selectedCell(index)
    }
}
