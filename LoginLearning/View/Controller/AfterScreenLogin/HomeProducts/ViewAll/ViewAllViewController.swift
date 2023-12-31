//
//  ViewAllViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 21/08/2566 BE.
//

import UIKit

class ViewAllViewController: UIViewController {
    var kodeAll: String = ""
    let productMV = ProductViewModel()
    @IBOutlet weak var collectionViewAll: UICollectionView!
    @IBOutlet weak var ketLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ketLabel.text = kodeAll
        
        collectionViewAll.dataSource = self
        collectionViewAll.delegate = self
        viewAll()

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewAll() {
        if kodeAll != "Brand" {
            let cellNib = UINib( nibName: "ProducCollectionViewCell", bundle:  nil)
            self.collectionViewAll.register(cellNib, forCellWithReuseIdentifier: "ProducCollectionViewCell" )
            productMV.loadProductAll {
                DispatchQueue.main.async {
                    self.collectionViewAll.reloadData()
                }
            }
        } else {
            let cellNib = UINib( nibName: "CollectionViewCell", bundle:  nil)
            self.collectionViewAll.register(cellNib, forCellWithReuseIdentifier: "CollectionViewCell" )
            
            productMV.loadBrand {
                DispatchQueue.main.async {
                    self.collectionViewAll.reloadData()
                }
            }
        }
    }
}


extension ViewAllViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if kodeAll == "Brand" {
            return productMV.brandCount
        } else {
            return productMV.productsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if kodeAll == "Brand" {
            if let cell = collectionViewAll.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
                let resultCategori = productMV.resultBrand.description[indexPath.item]
                cell.configure(data: resultCategori)
                return cell
                
            }
            
        } else {
            if let cell = collectionViewAll.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
                    let cellList = productMV.resultProduct.data[indexPath.item]
                    cell.configure(data: cellList)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if kodeAll == "Brand" {
            return CGSize(width: 170, height: 100)
        } else {
            return CGSize(width: 151, height: 328)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if kodeAll == "Brand" {
            return 5
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if kodeAll == "Brand" {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if kodeAll == "Brand" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailBrand = storyboard.instantiateViewController(withIdentifier: "DetailCategoryViewController") as! DetailCategoryViewController
            detailBrand.brandName = productMV.resultBrand.description[indexPath.item].name
            self.navigationController?.pushViewController(detailBrand , animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.idProduct = productMV.resultProduct.data[indexPath.item].id
            self.navigationController?.pushViewController(detailVC , animated: true)
        }

    }
    
    
    
    
}
