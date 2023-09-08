//
//  EditCardViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 06/09/2566 BE.
//

import UIKit
import CreditCardForm
import StripePaymentsUI

class EditCardViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var cvvCard: UITextField!
    @IBOutlet weak var expCard: UITextField!
    @IBOutlet weak var numberCard: UITextField!
    @IBOutlet weak var creditCardView: CreditCardFormView! {
        didSet{
            creditCardView.cardGradientColors[Brands.Amex.rawValue] = [UIColor.red, UIColor.black]
            creditCardView.cardNumberFont = UIFont(name: "HelveticaNeue", size: 20)!
            creditCardView.cardPlaceholdersFont = UIFont(name: "HelveticaNeue", size: 10)!
            creditCardView.cardTextFont = UIFont(name: "HelveticaNeue", size: 12)!
                }
    }
    
    @IBOutlet weak var nameCard: UITextField!
    
    private var cardParams: STPPaymentMethodCardParams!
    
    @IBOutlet weak var backBtn: UIButton!
    
    private var viewModel: EditCardVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyModel()
    }
    
    func configure(selectedCard: Card) {
        viewModel = EditCardVM(selectedCard: selectedCard)
    }
    
    private func applyModel() {
        nameCard.text = viewModel.selectedCard.nameCard
        cvvCard.text = viewModel.selectedCard.cvv
        expCard.text = "\(viewModel.selectedCard.expMonCard)/\(viewModel.selectedCard.expYearCard)"
        numberCard.text = viewModel.selectedCard.numberCard
        
        creditCardView.paymentCardTextFieldDidChange(cardNumber: viewModel.selectedCard.numberCard, expirationYear: UInt(viewModel.selectedCard.expYearCard), expirationMonth: UInt(viewModel.selectedCard.expMonCard), cvc: viewModel.selectedCard.cvv)
        
        creditCardView.cardHolderString = viewModel.selectedCard.nameCard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func cardNameTextChanged(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text ?? ""
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateActionBtn(_ sender: UIButton) {
     
        guard let name = nameCard.text else { return }
        guard let number = numberCard.text else { return }
        guard let exp = expCard.text else {return}
        guard let cvv = cvvCard.text else {return}
        
        if !nameCard.hasText {
            SnackBarWarning.make(in: self.view, message:"name card is Empty", duration: .lengthShort).show()
            return
        }
        
        if !numberCard.hasText {
            SnackBarWarning.make(in: self.view, message:"Number card is Empty", duration: .lengthShort).show()
            return
        }
        
        if !expCard.hasText {
            SnackBarWarning.make(in: self.view, message:"Exp card is Empty", duration: .lengthShort).show()
            return
        }
        
        if !cvvCard.hasText {
            SnackBarWarning.make(in: self.view, message:"CVC card is Empty", duration: .lengthShort).show()
            return
        }
            
        
        var expMont = ""
        var expYear = ""
        if let range = exp.firstIndex(of: "/") {
            expMont = String(exp.prefix(upTo: range))
            expYear =  String(exp.suffix(from: range).dropFirst())
        }
        
        let updateCard = Card(
        nameCard: name,
        numberCard: number,
        expMonCard: expMont,
        cvv: cvv, expYearCard: expYear)
        
        CardDataManager().updateCard(updateCard, number)
        self.navigationController?.popViewController(animated: true)
        
                
    }

    // MARK: - Navigation
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
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

extension EditCardViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text!
    }
}
