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

    @IBOutlet weak var nameOwner: UITextField! {
        didSet {
            nameOwner.addTarget(self, action: #selector(cardNameTextChanged(_:)), for: .editingChanged)
        }
    }
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
    
    @IBOutlet weak var inputCardText: STPPaymentCardTextField! {
        didSet {
            inputCardText.delegate = self
        }
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardParams = STPPaymentMethodCardParams()
        cardParams.number = inputCardText.cardNumber
        inputCardText.postalCodeEntryEnabled = false
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        creditCardView.paymentCardTextFieldDidChange(cardNumber: cardParams.number, expirationYear: cardParams.expYear as? UInt, expirationMonth: cardParams.expMonth as? UInt)
       
       
    }
    
    @objc func cardNameTextChanged(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text ?? ""
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        guard let nameCard = nameOwner.text else {return}
        guard let cardNumber = inputCardText.cardNumber else {return}
        let expMonth = "\(inputCardText.expirationMonth)"
        let expYear = "\(inputCardText.expirationYear)"
        guard let cardCvv = inputCardText.cvc else {return}
        
        if !nameOwner.hasText {
            SnackBarWarning.make(in: self.view, message:"name card is Empty", duration: .lengthShort).show()
            return
        }
        if !inputCardText.hasText {
            SnackBarWarning.make(in: self.view, message:"input Code Card is Empty", duration: .lengthShort).show()
            return
        }
        
        creditCardView.paymentCardTextFieldDidChange(cardNumber: cardParams.number, expirationYear: cardParams!.expYear as? UInt, expirationMonth: cardParams!.expMonth as? UInt, cvc: cardParams.cvc)
        
        guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
        
        
        let addCard = Card(
            nameCard: nameCard,
            numberCard: cardNumber,
            expMonCard: expMonth,
            cvv: cardCvv,
            expYearCard: expYear,
            userId: Int32(dataUser.id))
        DispatchQueue.main.async {
            CardDataManager().createCard(addCard)
            PaymentViewController.notifyObserver()
        }
        print("masuk")
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
//        if textField == nameCardText {
//            textField.resignFirstResponder()
//            inputCardText.becomeFirstResponder()
//        } else if textField == inputCardText {
//            textField.resignFirstResponder()
//        }
        return true
    }
}
