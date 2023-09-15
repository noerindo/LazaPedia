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
    var cardVM = PaymentVM()
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
        collectionCard.register(CardCreditCollectionViewCell.self, forCellWithReuseIdentifier: CardCreditCollectionViewCell.identifier)
        
        cardVM.reloadCollectionView = { [weak self] in
            self?.collectionCard.reloadData()
        }
        cardVM.loadCard {
            DispatchQueue.main.async { [self] in
                self.collectionCard.reloadData()
                if cardVM.cardList.count != 0 {
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.configurePayment(indexPath: indexPath)
                    emptyLabel.isHidden = false
                }
            }
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
            print("masuk reload card")
            DispatchQueue.main.async { [self] in
                self.collectionCard.reloadData()
                if cardVM.cardList.count != 0 {
                    if let selectedIndexPath = selectedIndexPath {
                        var previousIndexPath: IndexPath?
                        let currentItem = selectedIndexPath.item
                        if selectedIndexPath.item == 0 {
                            let totalItemsInSection = cardVM.cardList.count
                            previousIndexPath = IndexPath(item: currentItem, section: selectedIndexPath.section)
                            
                        } else if selectedIndexPath.item > 0 {
                            let totalItemsInSection = cardVM.cardList.count
                            previousIndexPath = IndexPath(item: totalItemsInSection - 1, section: selectedIndexPath.section)
                        }
                        if let previousIndexPath = previousIndexPath {
                            self.configurePayment(indexPath: previousIndexPath)
                        }
                    }
                    emptyLabel.isHidden = false
                } else {
                    self.nameCardView.text = ""
                    self.numberCard.text = ""
                    self.expCardView.text = ""
                    self.cvvCardView.text = ""
                }
                
            }
        }
    }
    
    
    func configurePayment(indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let card = cardVM.cardList[indexPath.item]
        self.nameCardView.text = card.nameCard
        self.numberCard.text = card.numberCard
        self.expCardView.text = "\(card.expMonCard)/\(card.expYearCard)"
        self.cvvCardView.text = "\(card.cvv)"
        self.collectionCard.reloadData()
    }
    
    @IBAction func editCardBtn(_ sender: UIButton) {
        let editAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCardViewController") as! EditCardViewController
        guard let name = nameCardView.text else {return}
        guard let number = numberCard.text else {return}
        guard let exp = expCardView.text else {return}
        guard let cvv = cvvCardView.text else {return}
        
        var expMont = ""
        var expYear = ""
        if let range = exp.firstIndex(of: "/") {
            expMont = String(exp.prefix(upTo: range))
            expYear =  String(exp.suffix(from: range).dropFirst())
        }
        
        guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
        
        let selectedCard = Card(
            nameCard: name,
            numberCard: number,
            expMonCard: expMont,
            cvv: cvv,
            expYearCard: expYear,
            userId: Int32(dataUser.id)
        )
        
        editAdressVC.configure(selectedCard: selectedCard)
        
        self.navigationController?.pushViewController(editAdressVC, animated: true)
        
    }
    @IBAction func chooseCardBtn(_ sender: UIButton) {
        guard let numberCrd = numberCard.text else {return}
        delegate?.sendCard(numberCard: numberCrd, isChoose: true)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func deleteCardBtn(_ sender: UIButton) {
        cardVM.deleteCard( creditCard: cardVM.cardList[selectedIndexPath!.item]) { result in
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
        emptyLabel.isHidden = cardVM.cardCount > 0
        return cardVM.cardCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCreditCollectionViewCell.identifier, for: indexPath) as? CardCreditCollectionViewCell {
            let cellList = cardVM.cardList[indexPath.item]
            cell.configureCard(data: cellList)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                cell.configureCard(data: cellList)
            }
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.configurePayment(indexPath: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let heightToWidthRatio: Double = Double(190) / Double(290)
        let height = width * heightToWidthRatio
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         // Menggunakan if let untuk memeriksa apakah selectedCellIndex tidak nil
         guard let selectedIndexPath = selectedIndexPath else { return }
//         print("\(scrollView.contentOffset.x) ")
         let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))

         // Dapatkan bagian (section) dari selectedIndexPath
         let selectedSection = selectedIndexPath.section
         let newIndexPath = IndexPath(item: currentIndex, section: selectedSection)
         self.configurePayment(indexPath: newIndexPath)
         if currentIndex != selectedIndexPath.row {

         }
     }
}


