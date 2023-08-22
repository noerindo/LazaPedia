//
//  TableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

protocol BrandTableViewCellDelegate: AnyObject {
    func moveBrandProduct(brand: Brand)
}

class TableViewCell: UITableViewCell {
    
    let productMV = ProductModelView()
    weak var delegateMove: BrandTableViewCellDelegate?
    
    @IBOutlet weak var collectionViewBrand: UICollectionView!
    @IBOutlet weak var btnSection: UIButton!
    @IBOutlet weak var titleSection: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewBrand.dataSource = self
        self.collectionViewBrand.delegate = self
        
        let cellNib = UINib( nibName: "CollectionViewCell", bundle:  nil)
        self.collectionViewBrand.register(cellNib, forCellWithReuseIdentifier: "CollectionViewCell" )
        
        productMV.loadBrand {
            DispatchQueue.main.async {
                self.collectionViewBrand.reloadData()
            }
        }
    }

    @IBAction func viewAllAction(_ sender: UIButton) {
        if let productAllVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllViewController") as? ViewAllViewController {
                   productAllVC.modalPresentationStyle = .fullScreen
            productAllVC.kodeAll = "Brand"
                   if let navigationController = self.window?.rootViewController as? UINavigationController {
                       navigationController.pushViewController(productAllVC, animated: false)
                   }
            }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension TableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(3,productMV.brandCount)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            let resultCategori = productMV.resultBrand.description[indexPath.item]
            cell.configure(data: resultCategori)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateMove?.moveBrandProduct(brand: productMV.resultBrand.description[indexPath.item])
        
    }
   
    
}
