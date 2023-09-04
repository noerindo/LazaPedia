//
//  WishlistViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class WishlistViewController: UIViewController {
    
    let wishlistMC = WishlistViewModel()
    @IBOutlet weak var collectionWishlist: UICollectionView!
    @IBOutlet weak var textEmpty: UILabel! {
        didSet {
            textEmpty.isHidden = true
        }
    }
    @IBOutlet weak var textCountWishlist: UILabel!
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Wishlist"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        
        tabBarItem.selectedImage = UIImage(view: label2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObserver()
        
        setupTabBarText()
        
        collectionWishlist.dataSource = self
        collectionWishlist.delegate = self
        collectionWishlist.register(UINib(nibName: "ProducCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProducCollectionViewCell")
        wishlistMC.loadWishList { result in
            DispatchQueue.main.async {
                self.collectionWishlist.reloadData()
                self.textCountWishlist.text = "\(result.data.total)"
            }
        }
        self.collectionWishlist.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:Notification.Name.UpdateWishlist, object: nil)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWishlist), name: Notification.Name.UpdateWishlist, object: nil)
    }
    
    static func notifyObserver() {
        NotificationCenter.default.post(name: Notification.Name.UpdateWishlist, object: nil)
    }
    
    @objc private func reloadWishlist() {
        wishlistMC.loadWishList { result in
            DispatchQueue.main.async {
                self.collectionWishlist.reloadData()
                self.textCountWishlist.text = "\(result.data.total)"
            }
        }
    }
    
}

extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(wishlistMC.listWishlist.count)
        if wishlistMC.listWishlist.count != 0 {
            textEmpty.isHidden = true
            
        } else {
            textEmpty.isHidden = false
        }
        return wishlistMC.listWishlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionWishlist.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
            let cellList = wishlistMC.listWishlist[indexPath.item]
                cell.configure(data: cellList)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 151, height: 328)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.idProduct = wishlistMC.listWishlist[indexPath.item].id
        self.navigationController?.pushViewController(detailVC , animated: true)
    }
    
}
