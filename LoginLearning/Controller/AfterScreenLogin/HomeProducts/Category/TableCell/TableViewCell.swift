//
//  TableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var apiResult = Categories()

    @IBOutlet weak var collectionViewBrand: UICollectionView!
    @IBOutlet weak var btnSection: UIButton!
    @IBOutlet weak var titleSection: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.collectionViewBrand.dataSource = self
        self.collectionViewBrand.delegate = self
        
        let cellNib = UINib( nibName: "CollectionViewCell", bundle:  nil)
        self.collectionViewBrand.register(cellNib, forCellWithReuseIdentifier: "CollectionViewCell" )
        
//        APICall.sharedApi.fetchAPICategory { categories in
//            DispatchQueue.main.async { [self] in
//                self.apiResult.append(contentsOf: categories)
//                collectionViewBrand.reloadData()
//            }
//        }
    }
    
}

extension TableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiResult.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            let resultCategori = apiResult[indexPath.row]
            cell.nameCategory.text = resultCategori.capitalized
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
        return CGSize(width: 150, height: 50)
    }
   
    
}
