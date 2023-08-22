//
//  DetailCategoryViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 21/08/2566 BE.
//

import UIKit

class DetailCategoryViewController: UIViewController {
    var brandName: String = ""
    let productMV = ProductModelView()
    weak var delegate: ProductTableViewCellDelegate?

    @IBOutlet weak var empthyView: UILabel! {
        didSet {
            empthyView.isHidden = true
        }
    }
    @IBOutlet weak var collectionProduct: UICollectionView!
    @IBOutlet weak var countProductBrand: UILabel!
    @IBOutlet weak var nameBrand: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameBrand.text = brandName
        collectionProduct.delegate = self
        collectionProduct.dataSource = self
        let cellNib = UINib( nibName: "ProducCollectionViewCell", bundle:  nil)
        self.collectionProduct.register(cellNib, forCellWithReuseIdentifier: "ProducCollectionViewCell" )
        productMV.loadBrandProductAll(nameBrand: brandName) {
            DispatchQueue.main.async {
                self.collectionProduct.reloadData()
                self.countProductBrand.text = "\(self.productMV.resultBrandProduct.data.count)"
            }
        }
        

    }
    
    @IBAction func sortProductAction(_ sender: UIButton) {
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productMV.allBrandProductCount == 0 {
            empthyView.isHidden = false
        } else {
            empthyView.isHidden = true
        }
        return productMV.allBrandProductCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
            let cellList = productMV.resultBrandProduct.data[indexPath.item]
            cell.configure(data: cellList)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 328)
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
        detailVC.idProduct = productMV.resultBrandProduct.data[indexPath.item].id
        self.navigationController?.pushViewController(detailVC , animated: true)
    }
    
}
