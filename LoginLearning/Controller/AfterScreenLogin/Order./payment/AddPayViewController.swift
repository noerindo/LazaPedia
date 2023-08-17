//
//  AddPayViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import CreditCardForm
import Stripe


class AddPayViewController: UIViewController,  STPPaymentCardTextFieldDelegate {
//
    private var cardParams: STPPaymentMethodCardParams!
    @IBOutlet weak var creditCardView: CreditCardFormView!{
                didSet{
        //            creditCardView.cardHolderString = "\(cardOwnerText)"
                    creditCardView.cardGradientColors[Brands.Amex.rawValue] = [UIColor.red, UIColor.black]
                    creditCardView.cardNumberFont = UIFont(name: "HelveticaNeue", size: 20)!
                    creditCardView.cardPlaceholdersFont = UIFont(name: "HelveticaNeue", size: 10)!
                    creditCardView.cardTextFont = UIFont(name: "HelveticaNeue", size: 12)!
                }
            }
   
    @IBOutlet weak var nameCardText: STPPaymentCardTextField!
    
    @IBOutlet weak var inputCardText: STPPaymentCardTextField! {
        didSet {
            inputCardText.delegate = self
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardParams = STPPaymentMethodCardParams()
        cardParams.number = inputCardText.cardNumber
        cardParams.expMonth = 03
        cardParams.expYear = 23
        cardParams.cvc = "1234"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        creditCardView.paymentCardTextFieldDidChange(cardNumber: cardParams.number, expirationYear: cardParams.expYear as? UInt, expirationMonth: cardParams.expMonth as? UInt)
       
       
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
//        creditCardView.cardHolderString = name
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
}

extension AddPayViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text!
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameCardText {
            textField.resignFirstResponder()
            inputCardText.becomeFirstResponder()
        } else if textField == inputCardText {
            textField.resignFirstResponder()
        }
        return true
    }
}
