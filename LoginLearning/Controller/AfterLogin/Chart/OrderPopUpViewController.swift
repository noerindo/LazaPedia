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
    
    private var viewModel = OrderPopUpVM()
    
    var isChooseAdress: Bool = false
    var isChooseCard: Bool = false
    var idAdres = 0
    
    @IBOutlet weak var numberCardText: UILabel!
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
        viewModel.loadAdress { _ in
            DispatchQueue.main.async {
                self.setDataOrder(orderInfo: self.viewModel.resultOrderInfo!)
            }
        }
        viewModel.loadCard {
            DispatchQueue.main.async { [self] in
                if viewModel.cardList.count > 0 {
                    numberCardText.text = viewModel.cardList.first!.numberCard
                    }
            }
        }
        
        if isChooseAdress != true {
            viewModel.loadAdress { adress in
                DispatchQueue.main.async { [self] in
                    let dataAdress = viewModel.resultAdress.data
                    if !dataAdress.isEmpty {
                        cityText.text = "\(dataAdress.first!.city)"
                        countryText.text = "\(dataAdress.first!.country)"
                        idAdres = dataAdress.first!.id
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.networkAPI.getAllChart { _ in
            DispatchQueue.main.async {
                self.setDataOrder(orderInfo: self.viewModel.resultOrderInfo!)
            }
        }
        if isChooseAdress != true {
            viewModel.loadAdress  { adress in
                DispatchQueue.main.async { [self] in
                    let dataAdress = viewModel.resultAdress.data
                    if !dataAdress.isEmpty {
                        cityText.text = "\(dataAdress.first!.city)"
                        countryText.text = "\(dataAdress.first!.country)"
                    } else {
                        cityText.text = "None"
                        countryText.text = "None"
                    }
                    
                }
            }
        }
        
        if isChooseCard != true {
            viewModel.loadCard {
                DispatchQueue.main.async { [self] in
                    if viewModel.cardList.count > 0 {
                        numberCardText.text = viewModel.cardList.first!.numberCard
                    } else {
                        numberCardText.text = "None"
                    }
                }
            }
        }
    }
    
    func setDataOrder(orderInfo: OrderInfo) {
        self.totalView.text = orderInfo.total.formatPrice()
        self.shippingText.text = orderInfo.shipping_cost.formatPrice()
        self.subTotalText.text = orderInfo.sub_total.formatPrice()
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
