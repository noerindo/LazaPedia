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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderMV.loadProductChart { [self] in
            DispatchQueue.main.async {
                self.setData(orderInfo: self.orderMV.resultOrderInfo!)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        orderMV.loadProductChart { [self] in
            DispatchQueue.main.async {
                self.setData(orderInfo: self.orderMV.resultOrderInfo!)
            }
        }
    }
    
    func setData(orderInfo: OrderInfo) {
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
