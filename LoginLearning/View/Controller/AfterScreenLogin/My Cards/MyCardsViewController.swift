////
////  MyCardsViewController.swift
////  LoginLearning
////
////  Created by Indah Nurindo on 17/08/2566 BE.
////
//
//import UIKit
//
//class MyCardsViewController: UIViewController {
//    
//    let cardModel = CreditCard()
//    @IBOutlet weak var textEmpty: UILabel!
//   
//    @IBOutlet weak var collectionCard: UICollectionView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTabBarText()
//        textEmpty.isHidden = true
//        collectionCard.dataSource = self
//        collectionCard.delegate = self
//        
//        collectionCard.register(UINib(nibName: "CardCreditCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCreditCollectionViewCell")
//    }
//    
//    private func setupTabBarText() {
//        let label = UILabel()
//        label.numberOfLines = 1
//        label.textAlignment = .center
//        label.text = "My Cards"
//        label.font = UIFont(name: "inter-Medium", size: 11)
//        label.sizeToFit()
//        
//        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg 1")
//        tabBarItem.selectedImage = UIImage(view: label)
//
////        tabBarItem.selectedImage = UIImage(view: label2)
//    }
//    
//}
//extension MyCardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if cardModel.count == 0 {
//            textEmpty.isHidden = false
//        } else {
//            textEmpty.isHidden = true
//        }
//        return cardModel.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionCard.dequeueReusableCell(withReuseIdentifier: "CardCreditCollectionViewCell", for: indexPath) as? CardCreditCollectionViewCell {
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//}
