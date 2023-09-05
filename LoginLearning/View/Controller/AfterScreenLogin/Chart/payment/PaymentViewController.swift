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
    
    weak var delegate: BtnBackDelegate?
     var cardDataManager = CardDataManager()
    var cardVM = CardViewModel()
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.isHidden = true
        }
    }
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
        
        registerObserver()
        
        collectionCard.dataSource = self
        collectionCard.delegate = self
        collectionCard.register(UINib(nibName: "CardCreditCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCreditCollectionViewCell")
        cardVM.loadCard {
            DispatchQueue.main.async {
                self.collectionCard.reloadData()
            }
        }
        if cardVM.cardCount != 0 {
            self.configurePayment(data: cardVM.cardList.first!)
            emptyLabel.isHidden = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:Notification.Name.UpdateCard, object: nil)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCard), name: Notification.Name.UpdateCard, object: nil)
    }
    
    static func notifyObserver() {
        NotificationCenter.default.post(name: Notification.Name.UpdateCard, object: nil)
    }
    
    @objc private func reloadCard() {
        cardVM.loadCard {
            DispatchQueue.main.async {
                self.collectionCard.reloadData()
            }
        }
    }
    
    func configurePayment(data: Card) {
        self.nameCardView.text = data.nameCard
        self.numberCard.text = data.numberCard
        self.expCardView.text = "\(data.expMonCard) / \(data.expYearCard)"
        self.cvvCardView.text = "\(data.cvv)"
        self.collectionCard.reloadData()
    }
    
    @IBAction func editCardBtn(_ sender: UIButton) {
        let addAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPayViewController") as! AddPayViewController
        addAdressVC.isEditCard = true
//        addAdressVC.nameOwner.text = cardVM.cardList[selectedIndexPath!.item].nameCard
//        addAdressVC.inputCardText
        self.navigationController?.pushViewController(addAdressVC, animated: true)
        
    }
    @IBAction func chooseCardBtn(_ sender: UIButton) {
        guard let numberCrd = numberCard.text else {return}
        delegate?.sendCard(numberCard: numberCrd, isChoose: true)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func deleteCardBtn(_ sender: UIButton) {
        cardVM.deleteCard( numberCard: cardVM.cardList[selectedIndexPath!.item].numberCard) { result in
            DispatchQueue.main.async {
                PaymentViewController.notifyObserver()
                SnackBarSuccess.make(in: self.view, message: result, duration: .lengthShort).show()
            }
        }
    }
    @IBAction func addCardAction(_ sender: UIButton) {
        let addAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPayViewController") as! AddPayViewController
        self.navigationController?.pushViewController(addAdressVC, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backOrderUp()
    }
}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cardVM.cardCount == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return cardVM.cardCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionCard.dequeueReusableCell(withReuseIdentifier: "CardCreditCollectionViewCell", for: indexPath) as? CardCreditCollectionViewCell {
            let cellList = cardVM.cardList[indexPath.item]
            cell.configureCard(data: cellList)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.configurePayment(data: cardVM.cardList[indexPath.item])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 290, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         // Menggunakan if let untuk memeriksa apakah selectedCellIndex tidak nil
         guard let selectedIndexPath = selectedIndexPath else { return }
//         print("\(scrollView.contentOffset.x) ")
         let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))

         // Dapatkan bagian (section) dari selectedIndexPath
         let selectedSection = selectedIndexPath.section
         let newIndexPath = IndexPath(item: currentIndex, section: selectedSection)
         let card = cardVM.cardList[newIndexPath.item]
         self.configurePayment(data: card)
         if currentIndex != selectedIndexPath.row {

         }
     }
    
   



}


