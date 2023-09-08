//
//  OrderViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit


class OrderViewController: UIViewController {
    
    private var viewModel = OrderViewVM()
    var idAdres: Int = 0
   
    lazy var bottomSheet = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderPopUpViewController")

    @IBOutlet weak var totalPriceText: UILabel!
    @IBOutlet weak var tableOrder: UITableView!
    
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObserver()
//        weak var delegate: BtnBackDelegate?
        setupTabBarText()
        tableOrder.delegate = self
        tableOrder.dataSource = self
        tableOrder.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        
        viewModel.loadProductChart { [weak self] in
            self!.viewModel.loadAllSize {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.tableOrder.reloadData()
                    self.totalPriceText.text = "$\(String(describing: self.viewModel.resultOrderInfo!.total))".formatDecimal()
                }
            }
        }
    
        viewModel.loadCard()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:Notification.Name.UpdateChart, object: nil)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCart), name: Notification.Name.UpdateChart, object: nil)
    }
    
    static func notifyObserver() {
        NotificationCenter.default.post(name: Notification.Name.UpdateChart, object: nil)
    }
    
    @objc private func reloadCart() {
        viewModel.loadProductChart {
            DispatchQueue.main.async { [self] in
                tableOrder.reloadData()
                totalPriceText.text = "$\(String(describing:viewModel.resultOrderInfo!.total))".formatDecimal()
            }
        }
    }
    
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Order"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        tabBarItem.selectedImage = UIImage(view: label2)
    }
    
    @IBAction func popUpActionBtn(_ sender: UIButton) {
        let tabVC = UINavigationController(rootViewController: bottomSheet)
        let vc = bottomSheet as? OrderPopUpViewController
        vc?.delegate = self
            if let sheet = tabVC.sheetPresentationController {
              sheet.detents = [.medium()]
            }
            self.present(tabVC, animated: true)
    }

    @IBAction func CheckoutAction(_ sender: UIButton) {
        if idAdres == 0 {
            if viewModel.resultAdress.data.isEmpty {
                let alert = UIAlertController(title: "Warning", message: "Adress is Empty. Add data Adress?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    DispatchQueue.main.async {
                        let loginVC = self?.storyboard?.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
                        self?.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            viewModel.loadAdress { [self] result in
                if !viewModel.resultAdress.data.isEmpty {
                    idAdres = result.data.first!.id
                }
            }
        }
        
        if viewModel.cardList.isEmpty {
            let alert = UIAlertController(title: "Warning", message: "card is Empty. Add Card?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                DispatchQueue.main.async {
                    let loginVC = self?.storyboard?.instantiateViewController(withIdentifier: "AddPayViewController") as! AddPayViewController
                    self?.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }

        viewModel.postChecOut(product: viewModel.resultzproductOrder, address_id: idAdres , onError: { errorMessage in
            print(errorMessage)
        })
        DispatchQueue.main.async {
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
            self.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
}

extension OrderViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyLabel.isHidden = viewModel.productCharCount > 0
        return viewModel.productCharCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell {
            let cellList = viewModel.resultProductChart[indexPath.item]
            cell.configure(data: cellList)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }
    
}

extension OrderViewController:BtnMoveIntoDelegate {
    func moveAdress() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdressViewController")
        //menghubungkan
        let adressVC = storyboard as? AdressViewController
        adressVC?.delegate = self
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func moveMethodPay() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController")
        //menghubungkan
        let payMetdoVC = storyboard as? PaymentViewController
        payMetdoVC?.delegate = self
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
}

extension OrderViewController: BtnBackDelegate {
    
    func sendCard(numberCard: String, isChoose: Bool) {
        let tabVC = UINavigationController(rootViewController: bottomSheet)
        let vc = bottomSheet as? OrderPopUpViewController
        vc?.delegate = self
            if let sheet = tabVC.sheetPresentationController {
              sheet.detents = [.medium()]
                vc!.numberCardText.text = numberCard
                vc!.isChooseCard = isChoose
            }
        self.present(tabVC, animated: true)
    }

    func sendAdressOrder(country: String, city: String, idAdress: Int,isChooseAdress: Bool) {
        self.idAdres = idAdress
        let tabVC = UINavigationController(rootViewController: bottomSheet)
        let vc = bottomSheet as? OrderPopUpViewController
              vc?.delegate = self
                  if let sheet = tabVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                  }
              vc!.cityText.text = city
              vc!.countryText.text = country
              vc!.isChooseAdress = true
              self.present(tabVC, animated: true)
    }
    
    func orderPopactive() {
        let tabVC = UINavigationController(rootViewController: bottomSheet)
        let vc = bottomSheet as? OrderPopUpViewController
        vc?.delegate = self
            if let sheet = tabVC.sheetPresentationController {
              sheet.detents = [.medium()]
            }
            self.present(tabVC, animated: true)
    }
    func backBtnOrderPop() {
        orderPopactive()
    }
    
    func backOrderUp() {
        orderPopactive()
    }
}

extension OrderViewController: OrderTableDelegate {
    func plusCountProduct(cell: OrderTableViewCell, completion: @escaping (Int) -> Void) {
        if let indexPath = tableOrder.indexPath(for: cell) {
            let dataCell = viewModel.resultProductChart[indexPath.item]
            let idSize = viewModel.GetIdSize(sizeString: dataCell.size)
            
            viewModel.postChart(idProduct: dataCell.id, idSize: idSize) { result in
                OrderViewController.notifyObserver()
                DispatchQueue.main.async {
                    completion(dataCell.quantity)
                }
            }
        }
    }
    
    func minCountProduct(cell: OrderTableViewCell) {
        if let indexPath = tableOrder.indexPath(for: cell) {
            let dataCell = viewModel.resultProductChart[indexPath.item]
           let idSize = viewModel.GetIdSize(sizeString: dataCell.size)
            viewModel.putProductChart(idProduct: dataCell.id, idSize: idSize)
            OrderViewController.notifyObserver()
        }
    }
    
    func deleteOrder(cell: OrderTableViewCell) {
        if let indexPath = tableOrder.indexPath(for: cell) {
            let dataCell = viewModel.resultProductChart[indexPath.item]
           let idSize = viewModel.GetIdSize(sizeString: dataCell.size)
            viewModel.deletProductChart(idProduct: dataCell.id, idSize: idSize) { result in
                OrderViewController.notifyObserver()
                DispatchQueue.main.async {
                    SnackBarSuccess.make(in: self.view, message: result, duration: .lengthShort).show()
                }
            }
        }
    }
}