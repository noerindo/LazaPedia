//
//  OrderPopUpViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

protocol BtnMoveIntoDelegate: AnyObject {
  func moveAdress()
  func moveMethodPay()
}

class OrderPopUpViewController: UIViewController {
    
    let orderMV = OrderModelView()
    let adressVM = AdressViewModel()
    var isChoose: Bool = false
    
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var shippingText: UILabel!
    @IBOutlet weak var subTotalText: UILabel!
    weak var delegate: BtnMoveIntoDelegate?
    @IBOutlet weak var viewBg: UIView! {
        didSet {
            viewBg.layer.cornerRadius = 20
        }
    }
    
    private var orderInfo: OrderInfo?
    
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var countryText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        orderMV.loadProductChart { [self] in
            DispatchQueue.main.async {
                self.setDataOrder(orderInfo: self.orderMV.resultOrderInfo!)
            }
        }
        if isChoose != true {
            adressVM.loadAdress { adress in
                DispatchQueue.main.async { [self] in
                    let dataAdress = adressVM.resultAdress.data
                    if !dataAdress.isEmpty {
                        cityText.text = "\(dataAdress.first!.city)"
                        countryText.text = "\(dataAdress.first!.country)"
                    }
                }
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        orderMV.loadProductChart { [self] in
            DispatchQueue.main.async {
                self.setDataOrder(orderInfo: self.orderMV.resultOrderInfo!)
            }
        }
        if isChoose != true {
            adressVM.loadAdress { adress in
                DispatchQueue.main.async { [self] in
                    let dataAdress = adressVM.resultAdress.data
                    if !dataAdress.isEmpty {
                        cityText.text = "\(dataAdress.first!.city)"
                        countryText.text = "\(dataAdress.first!.country)"
                    }
                }
            }
        }
    }
    
    func setDataOrder(orderInfo: OrderInfo) {
        self.totalView.text = "$\(orderInfo.total)".formatDecimal()
        self.shippingText.text = "$\(orderInfo.shipping_cost)".formatDecimal()
        self.subTotalText.text = "$\(orderInfo.sub_total)".formatDecimal()
    }
    
    @IBAction func deliveryAdressACtion(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate?.moveAdress()
    }
    
    
    @IBAction func paymentActionBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate?.moveMethodPay()
        
    }
    
}
