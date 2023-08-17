//
//  DetailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var photoProfil: UIImageView! {
        didSet {
            photoProfil.layer.cornerRadius = photoProfil.frame.size.width / 2
            photoProfil.clipsToBounds = true
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton! {
        didSet {
            let size = CGSize(width: 35, height: 35)
            let rect = CGRect(origin: .zero, size: size)
            var image = UIImage(named: "Heart")
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            image?.draw(in: rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            favoriteBtn.setImage(image, for: .normal)
        }
    }
    var sizeBaju = ["S", "M", "L","XL", "2XL", "3XL"]
    var product: ProducList?
    @IBOutlet weak var photoProduc: UIImageView!
    @IBOutlet weak var categoryView: UILabel! {
        didSet {
            categoryView.font = UIFont(name: "Inter-Regular", size: 13)
        }
    }
    
    @IBOutlet weak var nameProduk: UILabel! {
        didSet {
            nameProduk.font = UIFont(name: "Inter-SemiBold", size: 22)
        }
    }
    @IBOutlet weak var priceProduk: UILabel! {
        didSet {
            priceProduk.font = UIFont(name: "Inter-SemiBold", size: 22)
        }
    }
    @IBOutlet weak var priceText: UILabel! {
        didSet {
            priceText.font = UIFont(name: "Inter-Regular", size: 13)
        }
    }
    @IBOutlet weak var descProduc: UILabel!
    @IBOutlet weak var collectionSize: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(String(describing: product))
        
        collectionSize.delegate = self
        collectionSize.dataSource = self
        viewDetailProduc()
        collectionSize.register(UINib(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
        collectionSize.reloadData()

        
        
    }
    func viewDetailProduc(){
        nameProduk.text = product?.title
        priceProduk.text = "$ \(product?.price ?? 0)"
        categoryView.text = product?.category
        descProduc.text = product?.description
        
        let imgURl = URL(string: "\(product?.image ?? "")")
        self.photoProduc.sd_setImage(with: imgURl)
        
        
    }
    
    @IBAction func detailRiview(_ sender: Any) {
        let riviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        self.navigationController?.pushViewController(riviewVC, animated: true)
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}




extension DetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizeBaju.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell {
            cell.sizeText.text = sizeBaju[indexPath.row]
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
        return CGSize(width: 60, height: 60)
    }

}
