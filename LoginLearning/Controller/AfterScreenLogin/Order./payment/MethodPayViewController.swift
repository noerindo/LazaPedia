//
//  MethodPayViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class MethodPayViewController: UIViewController {
    weak var delegate: BtnBackDelegate?
    private var choosePay: String = ""

    @IBOutlet weak var bgGopay: UIView!
    @IBOutlet weak var checkCard: UIButton!  {
        didSet {
            checkCard.addTarget(self, action: #selector(shoosePayment), for: .touchUpInside)
            checkCard.setImage(UIImage(systemName: "circle"), for: .normal)
            
        }
    }
    @IBOutlet weak var checkGopay: UIButton! {
        didSet {
            checkGopay.addTarget(self, action: #selector(chooseGopay), for: .touchUpInside)
            checkGopay.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    @IBOutlet weak var bgCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func chooseGopay() {
        if checkGopay.currentImage == UIImage(systemName: "circle") {
           choosePay = "GoPay"
            checkGopay.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkCard.setImage(UIImage(systemName: "circle"), for: .normal)
            
        } else {
            checkGopay.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @objc func shoosePayment() {
        if checkCard.currentImage == UIImage(systemName: "circle") {
           choosePay = "Payment"
            checkCard.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        checkGopay.setImage(UIImage(systemName: "circle"), for: .normal)
            
        } else {
            checkCard.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
       
    @IBAction func paymantActionBtn(_ sender: Any) {
        if choosePay == "GoPay" {
            let goPayVC = self.storyboard?.instantiateViewController(withIdentifier: "GopayViewController") as! GopayViewController
            self.navigationController?.pushViewController(goPayVC, animated: true)
        } else if choosePay == "Payment" {
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
            self.navigationController?.pushViewController(paymentVC, animated: true)
        } else {
            SnackBarWarning.make(in: self.view, message: "Pilih Metode Pembayaran", duration: .lengthShort).show()
        }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backOrderUp()
    }
    
}
