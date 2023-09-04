//
//  DetailViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {
    let productMV = ProductViewModel()
    let wishlistMV = WishlistViewModel()
    let orderMV = OrderViewModel()
    var idProduct: Int = 0
    var idSize: Int = 0
    var selectedSizeIndexPath: IndexPath?
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
        productMV.loadDetail(id: idProduct) {
            DispatchQueue.main.async {
                self.collectionSize.reloadData()
                self.configureDetail(model: self.productMV.resultDetail!)
            }
        }
        updateWishlistBtn()
    }
    
    func updateWishlistBtn() {
        wishlistMV.loadWishList(completion: { wishlistList in
            print("Completion updateWishlistBtn")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                wishlistList.data.products.forEach { productList in
                    if productList.id == self.idProduct {
                        self.favoriteBtn.setImage(UIImage(systemName: "suit.heart.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
                        self.isInWishlist = true
                        return
                    }
                }
            }
        })
    }
    func configureDetail(model: ProductDetail) {
        nameProduk.text = "\(model.data.name)"
        priceText.text = "$ \(model.data.price)".formatDecimal()
        descProduc.text = "\(model.data.description)"
        categoryView.text = "\(model.data.category.category)"
        photoProduc.sd_setImage(with: URL(string: "\(model.data.image_url)"))
        
        let riview = model.data.reviews.first
        dateUser.text = riview!.created_at.dateReview(date: "\(riview!.created_at)")
        ratingText.text = "\(riview!.rating)"
        starRating.rating = riview!.rating
        nameUser.text = "\(riview!.full_name)"
        textRiview.text = "\(riview!.comment)"
        photoProfil.sd_setImage(with: URL(string: "\( riview!.image_url)"))
        
    }
    
    @IBAction func wishlistBtn(_ sender: UIButton) {
        if isInWishlist! {
            actionWishlist(sender)
        } else {
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
                    WishlistViewController.notifyObserver()
                    SnackBarSuccess.make(in: self.view, message: wishlist, duration: .lengthShort).show()
                } else {
                    self.isInWishlist?.toggle()
                    self.setButtonBackGround(
                        view: sender,
                        on: UIImage(systemName: "suit.heart.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal),
                        off: UIImage(systemName: "suit.heart")!,
                        onOffStatus: self.isInWishlist!
                    )
                    WishlistViewController.notifyObserver()
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
//        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
     
    
    @IBAction func addChart(_ sender: UIButton) {
        if idSize != 0 {
            orderMV.postChart(idProduct: idProduct, idSize: idSize) { result in
                OrderViewController.notifyObserver()
                DispatchQueue.main.async {
                    SnackBarSuccess.make(in: self.view, message: "Succes Add to Order", duration: .lengthShort).show()
                }
            }
        } else {
            SnackBarWarning.make(in: self.view, message: "Please choose your size product", duration: .lengthShort).show()
        }
    }
}

extension DetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productMV.sizeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell {
            cell.sizeText.text = productMV.sizeProduct[indexPath.row].size
            if indexPath == selectedSizeIndexPath {
                cell.bgSize.backgroundColor = UIColor(named: "colorBg 1")
            } else {
                cell.bgSize.backgroundColor = UIColor(named: "colorBtn")
            }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSizeIndexPath = indexPath
        self.idSize = productMV.sizeProduct[indexPath.row].id
        collectionSize.reloadData()
    }
    
}
