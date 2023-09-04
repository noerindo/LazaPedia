//
//  PaymentViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import Stripe
import CreditCardForm

class PaymentViewController: UIViewController {
   
     var cardDataManager = CardDataManager()
    var cardVM = CardViewModel()
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var editCrad: UIButton! {
        didSet {
            editCrad.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var deletCard: UIButton! {
        didSet {
            deletCard.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var numberCard: UITextField! {
        didSet {
            numberCard.isEnabled = false
        }
    }
    @IBOutlet weak var nameCardView: UITextField! {
        didSet {
            nameCardView.isEnabled = false
        }
    }
    @IBOutlet weak var collectionCard: UICollectionView!
    @IBOutlet weak var expCardView: UITextField! {
        didSet {
            expCardView.isEnabled = false
        }
    }
    @IBOutlet weak var cvvCardView: UITextField! {
        didSet {
            cvvCardView.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionCard.dataSource = self
        collectionCard.delegate = self
        collectionCard.register(UINib(nibName: "CardCreditCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCreditCollectionViewCell")
        cardVM.loadCard {
            DispatchQueue.main.async {
                self.collectionCard.reloadData()
//                self.configurePayment(data: self.cardVM.cardList[])
            }
        }
                
    }
    @IBAction func addCardAction(_ sender: UIButton) {
        let addAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPayViewController") as! AddPayViewController
        self.navigationController?.pushViewController(addAdressVC, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configurePayment(data: Card) {
        self.nameCardView.text = data.nameCard
        self.numberCard.text = data.numberCard
        self.expCardView.text = "\(data.expMonCard) / \(data.expYearCard)"
        self.cvvCardView.text = "\(data.cvv)"
    }
    
}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("iniiiiii \(cardVM.cardCount)")
        return cardVM.cardCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionCard.dequeueReusableCell(withReuseIdentifier: "CardCreditCollectionViewCell", for: indexPath) as? CardCreditCollectionViewCell {
            let cellList = cardVM.cardList[indexPath.row]
            cell.configureCard(data: cellList)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let card = cardVM.cardList[indexPath.item]
        self.configurePayment(data: card)
    }


}


