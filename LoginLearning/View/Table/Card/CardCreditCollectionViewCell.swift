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

    @IBOutlet weak var cardView: CreditCardFormView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCard(data: Card) {
        let nameCard = data.nameCard
        let numberCard = data.numberCard
        let expMon = data.expMonCard
        let expYear = data.expYearCard
        let cvv = data.cvv
        
        cardView.paymentCardTextFieldDidChange(cardNumber: numberCard, expirationYear: UInt(expYear), expirationMonth: UInt(expMon), cvc: cvv)
        cardView.cardHolderString = nameCard
    }
    
    // MARK: - Func Credit Card
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingCVC()
    }

}
