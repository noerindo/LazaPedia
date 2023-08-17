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
    
    
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionProduct: DynamicHeightCollectionView!
    @IBOutlet weak var newArraival: UILabel!
    
    // deklasi delegatenya
    weak var delegate: ProductTableViewCellDelegate?
//    weak var delegateSearch: HomeProductionDelegate?
    var resultProduct = [ProducList]()
    var isSearchBar: Bool = false
    var textSearch: String = ""
    var produkFilter: [ProducList] = []
    
    var isLoading: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionProduct.delegate = self
        collectionProduct.dataSource = self
        
        let cellNib = UINib( nibName: "ProducCollectionViewCell", bundle:  nil)
        self.collectionProduct.register(cellNib, forCellWithReuseIdentifier: "ProducCollectionViewCell" )
      
//        APICall.sharedApi.fetchAPIProduct { producIndex in
//            DispatchQueue.main.async {
//                self.resultProduct.append(contentsOf: producIndex)
//                self.collectionProduct.reloadData()
//                self.delegate?.fetchApiDone()
////                for produk in resultProduct {
////                    if produk.title.lowercased().contains(delegateSearch.)
////                }
//            }
//        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProducTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchBar == true {
            return produkFilter.count
        } else {
            return resultProduct.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
            if isSearchBar == true {
                let cellList = produkFilter[indexPath.item]
                cell.configure(data: cellList)
            } else {
                let cellList = resultProduct[indexPath.item]
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
            delegate?.scDetailProduct(product:resultProduct[indexPath.item])
        }
       
    }
}

extension ProducTableViewCell: HomeProductionDelegate {
    
    func fetchSearch(isActive: Bool, textString: String) {
        print("Search: ", textString)
        isSearchBar = isActive
        produkFilter = resultProduct.filter{ $0.title.contains(textString) }
        print(produkFilter)
        self.collectionProduct.reloadData()
    }
}
