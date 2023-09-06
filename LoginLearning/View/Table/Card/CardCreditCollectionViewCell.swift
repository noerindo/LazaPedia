//
//  CardCreditCollectionViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import CreditCardForm
import StripePaymentsUI

class CardCreditCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CardCreditCollectionViewCell"
       static func nib() -> UINib {
           return UINib(nibName: "CardCreditCollectionViewCell", bundle: nil)
       }

//    @IBOutlet weak var cardView: CreditCardFormView!
    
    private let creditCard: CreditCardFormView = {
           let card = CreditCardFormView()
           card.translatesAutoresizingMaskIntoConstraints = false
           return card
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupCard()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupCard()
       }
       
       override func awakeFromNib() {
           super.awakeFromNib()
           setupCard()
           print(creditCard.frame.width, creditCard.frame.height, separator: " : ")
       }

       private func setupCard() {
           contentView.addSubview(creditCard)
           NSLayoutConstraint.activate([
               creditCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               creditCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
               creditCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
               creditCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
           ])
       }
       
       func configureCard(data: Card) {
           let nameCard = data.nameCard
           let numberCard = data.numberCard
           let expMon = data.expMonCard
           let expYear = data.expYearCard
           let cvv = data.cvv
           
           creditCard.paymentCardTextFieldDidChange(cardNumber: numberCard, expirationYear: UInt(expYear), expirationMonth: UInt(expMon), cvc: cvv)
           creditCard.cardHolderString = nameCard
       }
}
//    override func awakeFromNib() {
        
        
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    func configureCard(data: Card) {
//        let nameCard = data.nameCard
//        let numberCard = data.numberCard
//        let expMon = data.expMonCard
//        let expYear = data.expYearCard
//        let cvv = data.cvv
//
//        cardView.paymentCardTextFieldDidChange(cardNumber: numberCard, expirationYear: UInt(expYear), expirationMonth: UInt(expMon), cvc: cvv)
//        cardView.cardHolderString = nameCard
//    }
//
//    // MARK: - Func Credit Card
//    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
//        cardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
//
//    }
//
//    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
//        cardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
//    }
//
//    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
//        cardView.paymentCardTextFieldDidBeginEditingCVC()
//    }
//
//    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
//        cardView.paymentCardTextFieldDidEndEditingCVC()
//    }
//
//}
