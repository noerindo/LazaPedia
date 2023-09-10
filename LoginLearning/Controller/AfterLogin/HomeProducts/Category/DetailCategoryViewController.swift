//
//  DetailCategoryViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 21/08/2566 BE.
//

import UIKit

class DetailCategoryViewController: UIViewController {
  
    var viewModel: DetailCategoryVM!
    weak var delegate: ProductTableViewCellDelegate?
    var brandProduct = [ProducList]()

    @IBOutlet weak var sortItemBtn: UIButton! {
        didSet {
            sortItemBtn.setImage(UIImage(systemName: " "), for: .normal)
            sortItemBtn.setTitle("Sort", for: .normal)
        }
    }
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
        nameBrand.text = viewModel.brandName
        collectionProduct.delegate = self
        collectionProduct.dataSource = self
        let cellNib = UINib( nibName: "ProducCollectionViewCell", bundle:  nil)
        self.collectionProduct.register(cellNib, forCellWithReuseIdentifier: "ProducCollectionViewCell" )
        viewModel.loadBrandProductAll(nameBrand: viewModel.brandName) {
            DispatchQueue.main.async {
                self.brandProduct = self.viewModel.resultBrandProduct.data
                self.collectionProduct.reloadData()
                self.countProductBrand.text = "\(self.viewModel.resultBrandProduct.data.count)"
            }
        }
        sortItemData()
    }
    
    func configure(brandName: String) {
        viewModel = DetailCategoryVM(brandName: brandName)
    }
    
    func sortItemData() {
      if sortItemBtn.currentImage == UIImage(systemName: "") {
          let sort = brandProduct.sorted { $0.name < $1.name }
          brandProduct = sort
         sortItemBtn.setImage(UIImage(systemName: "text.line.first.and.arrowtriangle.forward"), for: .normal)
          sortItemBtn.setTitle("Sort", for: .normal)
      } else if sortItemBtn.currentImage == UIImage(systemName: "text.line.first.and.arrowtriangle.forward") {
          let sort = brandProduct.sorted { $0.name > $1.name }
          brandProduct = sort
          sortItemBtn.setImage(UIImage(systemName: "text.line.last.and.arrowtriangle.forward"), for: .normal)
          sortItemBtn.setTitle("Z-A", for: .normal)
      } else if sortItemBtn.currentImage == UIImage(systemName: "text.line.last.and.arrowtriangle.forward") {
          let sort = brandProduct.sorted{ $0.name < $1.name }
          brandProduct = sort
          sortItemBtn.setImage(UIImage(systemName: "text.line.first.and.arrowtriangle.forward"), for: .normal)
          sortItemBtn.setTitle("A-Z", for: .normal)
      }
        collectionProduct.reloadData()
    }
    
    @IBAction func sortProductAction(_ sender: UIButton) {
        sortItemData()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        empthyView.isHidden = viewModel.allBrandProductCount > 0
        return viewModel.allBrandProductCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "ProducCollectionViewCell", for: indexPath) as? ProducCollectionViewCell {
            let cellList = brandProduct[indexPath.item]
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
        let id = brandProduct[indexPath.item].id
        detailVC.configure(idProduct: id)
        self.navigationController?.pushViewController(detailVC , animated: true)
    }
    
}
