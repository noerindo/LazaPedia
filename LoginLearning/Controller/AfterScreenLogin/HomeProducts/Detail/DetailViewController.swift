//
//  DetailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {
    let productMV = ProductModelView()
    let wishlistMV = WishlistViewModel()
    var idProduct: Int = 0
    var isInWishlist: Bool? = false
    
    @IBOutlet weak var dateUser: UILabel!
    
    @IBOutlet weak var starRating: CosmosView! {
        didSet {
            starRating.settings.fillMode = .precise
            starRating.settings.updateOnTouch = false
            starRating.settings.totalStars = 5
            starRating.settings.starMargin = 1
        }
    }
    @IBOutlet weak var textRiview: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var photoProfil: UIImageView! {
        didSet {
            photoProfil.layer.cornerRadius = photoProfil.frame.size.width / 2
            photoProfil.clipsToBounds = true
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!
    //    {
    //        didSet {
    //            let size = CGSize(width: 35, height: 35)
    //            let rect = CGRect(origin: .zero, size: size)
    //            var image = UIImage(systemName: "Heart")
    //            UIGraphicsBeginImageContextWithOptions(size, false, 1)
    //            image?.draw(in: rect)
    //            image = UIGraphicsGetImageFromCurrentImageContext()
    //            favoriteBtn.setImage(image, for: .normal)
    //        }
    //    }
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
        collectionSize.delegate = self
        collectionSize.dataSource = self
        collectionSize.register(UINib(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
        productMV.detailProductVC = self
        productMV.loadDetail(id: idProduct)
        collectionSize.reloadData()
        updateWishlistBtn()
    }
    
    func updateWishlistBtn() {
        
        wishlistMV.loadWishList(completion: { wishlistList in
            print("Completion updateWishlistBtn")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("iniiiiii \(wishlistList)")
                wishlistList.data.products.forEach { productList in
                    print("wishlist id: \(productList.id), product id: \(self.idProduct)")
                    if productList.id == self.idProduct {
                        self.favoriteBtn.setImage(UIImage(systemName: "suit.heart.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
                        self.isInWishlist = true
                        return
                    }
                }
            }
        })
    }
    
    @IBAction func wishlistBtn(_ sender: UIButton) {
        if isInWishlist! {
            print("hapus")
            actionWishlist(sender)
        } else {
            print("save")
            actionWishlist(sender)
        }
    }
    private func actionWishlist(_ sender: UIButton) {
        wishlistMV.putWishlist(id: idProduct) { wishlist in
            DispatchQueue.main.async {
                if wishlist == "successfully added wishlist" {
                    self.isInWishlist?.toggle()
                    self.setButtonBackGround(
                        view: sender,
                        on: UIImage(systemName: "suit.heart.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal),
                        off: UIImage(systemName: "suit.heart")!,
                        onOffStatus: self.isInWishlist!
                    )
                    SnackBarSuccess.make(in: self.view, message: wishlist, duration: .lengthShort).show()
                } else {
                    self.isInWishlist?.toggle()
                    self.setButtonBackGround(
                        view: sender,
                        on: UIImage(systemName: "suit.heart.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal),
                        off: UIImage(systemName: "suit.heart")!,
                        onOffStatus: self.isInWishlist!
                    )
                    SnackBarSuccess.make(in: self.view, message: wishlist, duration: .lengthShort).show()
                }
            }
        }
    }
    
    private func setButtonBackGround(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
        case true:
            view.setImage(on, for: .normal)
        default:
            view.setImage(off, for: .normal)
        }    }
    
    @IBAction func detailRiview(_ sender: Any) {
        let riviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        riviewVC.idProduct = idProduct
        self.navigationController?.pushViewController(riviewVC, animated: true)
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}




extension DetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productMV.sizeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell {
            cell.sizeText.text = productMV.sizeProduct[indexPath.row].size
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
