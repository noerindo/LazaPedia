//
//  ProducTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

//buat protocol untuk menmapung reload fetch apinya
protocol ProductTableViewCellDelegate: AnyObject {
    func fetchApiDone()
    func scDetailProduct(product: ProducList)
}

class ProducTableViewCell: UITableViewCell {
    
    let productMV = ProductModelView()
    var produkFilter: [ProducList] = []
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionProduct: DynamicHeightCollectionView!
    @IBOutlet weak var newArraival: UILabel!
    
    var isSearchBar: Bool = false
    // deklasi delegatenya
        weak var delegate: ProductTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionProduct.delegate = self
        collectionProduct.dataSource = self
        
        let cellNib = UINib( nibName: "ProducCollectionViewCell", bundle:  nil)
        self.collectionProduct.register(cellNib, forCellWithReuseIdentifier: "ProducCollectionViewCell" )
        productMV.loadProductAll {
            DispatchQueue.main.async {
                self.collectionProduct.reloadData()
                self.delegate?.fetchApiDone()
            }
        }
    }
    
    @IBAction func viewAllAction(_ sender: UIButton) {
        if let productAllVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllViewController") as? ViewAllViewController {
                   productAllVC.modalPresentationStyle = .fullScreen
            productAllVC.kodeAll = "Product"
                   if let navigationController = self.window?.rootViewController as? UINavigationController {
                       navigationController.pushViewController(productAllVC, animated: false)
                   }
            }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

}
    
}

extension ProducTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchBar == true {
            return produkFilter.count
        } else {
            return min(6, productMV.productsCount)
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
            if isSearchBar == true {
                let cellList = produkFilter[indexPath.item]
                cell.configure(data: cellList)
            } else {
                let cellList = productMV.resultProduct.data[indexPath.item]
                cell.configure(data: cellList)
            }

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
        
        if isSearchBar == true {
            delegate?.scDetailProduct(product: produkFilter[indexPath.item])
        } else {
            delegate?.scDetailProduct(product:productMV.resultProduct.data[indexPath.item])
        }

    }
}

extension ProducTableViewCell: HomeProductionDelegate {
    
    func fetchSearch(isActive: Bool, textString: String) {
        isSearchBar = isActive
        produkFilter = productMV.resultProduct.data.filter{$0.name.lowercased().contains(textString.lowercased())}
        self.collectionProduct.reloadData()
    }
}


