//
//  WishlistViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class WishlistViewController: UIViewController {
    @IBOutlet weak var collectionWishlist: UICollectionView!
    @IBOutlet weak var textEmpty: UILabel!
    var producFavorite: NSArray = []
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
        setupTabBarText()
        collectionWishlist.dataSource = self
        collectionWishlist.delegate = self
        
        collectionWishlist.register(UINib(nibName: "ProducCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProducCollectionViewCell")
    }
}

extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if producFavorite.count == 0 {
            textEmpty.isHidden = false
            
        } else {
            textEmpty.isHidden = true
        }
        return producFavorite.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionWishlist.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
