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
   
    
    @IBOutlet weak var addAdress: UIButton! {
        didSet {
            addAdress.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var collectionCard: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionCard.dataSource = self
        collectionCard.delegate = self
        collectionCard.register(UINib(nibName: "CardCreditCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCreditCollectionViewCell")
        

    }
    @IBAction func addAdressBtn(_ sender: UIButton) {
        let addAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPayViewController") as! AddPayViewController
        self.navigationController?.pushViewController(addAdressVC, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionCard.dequeueReusableCell(withReuseIdentifier: "CardCreditCollectionViewCell", for: indexPath) as? CardCreditCollectionViewCell {
            return cell
            
        }
        return UICollectionViewCell()
    }


}


