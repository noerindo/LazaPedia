//
//  HomeProducViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 28/07/2566 BE.
//

import UIKit
import SideMenu

protocol HomeProductionDelegate: AnyObject {
    func fetchSearch(isActive: Bool, textString: String)
}

class HomeProducViewController: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    
    // delegate protocol
    weak var delegate: HomeProductionDelegate?
    
    var isMenuClick: Bool = false
    var searchActive: Bool = false
    var blurEffectView: UIVisualEffectView?
    
    lazy var parentBluerView: UIVisualEffectView = {
        var blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .light)
        let size = CGSize(width: view.frame.size.width/2, height: view.frame.size.height)
        blurView.frame = CGRect(origin: .zero, size: size)
        return blurView
    }()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var homeTable: IntrinsicTableView!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var sideBtn: UIButton! {
        didSet {
            let size = CGSize(width: 30, height: 30)
            let rect = CGRect(origin: .zero, size: size)
            var image = UIImage(named: "sideOff")
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            image?.draw(in: rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            sideBtn.setImage(image, for: .normal)
            sideBtn.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        }
    }
    
    private var sideMenuNavController: SideMenuNavigationController?
    
    @objc func sideMenuAction() {
        if isMenuClick {
            isMenuClick = false
            parentBluerView.isHidden = true
        } else {
            isMenuClick = true
            parentBluerView.isHidden = false
//            performSegue(withIdentifier: "SideMenuViewController", sender: nil)
            present(sideMenuNavController!, animated: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarText()
        setupSideMenu()
        
        view.addSubview(parentBluerView)
        parentBluerView.isHidden = true
    // side Btn
        
        homeTable.dataSource = self
        homeTable.delegate = self
        
        homeTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        homeTable.register(UINib(nibName: "ProducTableViewCell", bundle: nil), forCellReuseIdentifier: "ProducTableViewCell")
        
    }
    
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Home"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label2)
    }

    private func setupSideMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController else { return }
        vc.delegate = self
        
        sideMenuNavController = SideMenuNavigationController(rootViewController: vc)
        sideMenuNavController?.delegate = self
        sideMenuNavController?.leftSide = true
        sideMenuNavController?.menuWidth = view.bounds.width * 0.8
        sideMenuNavController?.presentationStyle = .menuSlideIn
        sideMenuNavController?.navigationBar.isHidden = true
    }
    
    func cekAcces() {
        var acces1 = KeychainManager.shared.getTokenValid()
         if acces1 == "Login lagi" {
             let alert = UIAlertController(title: "Warning", message: "Token is expired, please re-login", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "OK", style: .default) { _ in
               DispatchQueue.main.async {
                   
               }
             }
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
         }
    }
}

extension HomeProducViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            if let cellBrand = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell {
                cellBrand.delegateMove = self
                return cellBrand
            }
            return UITableViewCell()
        } else {
            if let cellProduct = tableView.dequeueReusableCell(withIdentifier: "ProducTableViewCell", for: indexPath) as? ProducTableViewCell  {
                // delegate ini kita panggil dari protocol di home
                cellProduct.delegate = self
                self.delegate = cellProduct // Buat search
                return cellProduct
            }
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 1 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }

}
 // menghubungkan dengan home table melalu protocol
extension HomeProducViewController: ProductTableViewCellDelegate {
    
    func scDetailProduct(product: ProducList) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.idProduct = product.id
        self.navigationController?.pushViewController(detailVC , animated: true)
    }
    
    func fetchApiDone() {
        homeTable.reloadData()
    }
    
}

extension HomeProducViewController: BrandTableViewCellDelegate {
    func moveBrandProduct(brand: Brand) {
        print("Brand on \(brand)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailBrand = storyboard.instantiateViewController(withIdentifier: "DetailCategoryViewController") as! DetailCategoryViewController
        detailBrand.brandName = brand.name
        self.navigationController?.pushViewController(detailBrand , animated: true)
    }
    
}

extension HomeProducViewController: SideMenuNavigationControllerDelegate, UINavigationControllerDelegate {
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        parentBluerView.isHidden = true
    }
}

extension HomeProducViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
        } else {
            delegate?.fetchSearch(isActive: true, textString: searchText)
            homeTable.reloadData()
        }
    }
}

extension HomeProducViewController: SideMenuViewControllerDelegate {
    func changePassword() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changePassVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.pushViewController(changePassVC , animated: true)
    }
    
    func selectedCell(_ row: Int) {
        tabBarController?.selectedIndex = row
    }
}
