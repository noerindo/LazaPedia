//
//  OrderViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class OrderViewVM {
    let networkAPI = NetworkAPI()
    var resultProductChart = [ProductChart]()
    var resultOrderInfo: OrderInfo?
    var resultzproductOrder = [DataProduct]()
    var resultAllSize = [Size]()
    var resultAdress = GetAllAdres(data: [DataAdress]())
    var cardList = [Card]()
    var totalPrice: Int?
    
    var reloadCollectionView: (() -> Void)?
    
    private lazy var cardDataManager: CardDataManager = {
        return CardDataManager()
    }()
    
    var productCharCount: Int {
        get {
            return resultProductChart.count
        }
    }
    
    func GetIdSize(sizeString: String) -> Int {
        for size in resultAllSize {
            if size.size == sizeString {
                return size.id
            }
        }
        return 0
    }
    
    func loadAdress() {
        networkAPI.getAdress { adress in
            DispatchQueue.main.async { [self] in
                let Primary = adress.data.filter { $0.is_primary != nil}
                let unPrimary = adress.data.filter { $0.is_primary == nil}
                resultAdress.data = Primary + unPrimary
                print("ini coun adress \(resultAdress.data.count)")
            }
        }
    }
    
    func loadCard() {
        self.cardDataManager.getCard { card in
            DispatchQueue.main.async {
                self.cardList.append(contentsOf: card)
            }
        }
    }
    
    func loadAllSize(completion: @escaping () -> Void) {
        networkAPI.getAllSize { sizen in
            DispatchQueue.main.async {
                self.resultAllSize = sizen!.data
                completion()
            }
        } onError: { error in
            print(error)
        }
    }
    
    func  loadProductChart(completion: @escaping (() -> Void)) {
        networkAPI.getAllChart { result in
            DispatchQueue.main.async { [weak self] in
                guard let result = result else { return }
                guard let products = result.data.products else {
                    self?.resultOrderInfo = result.data.order_info
                    self?.resultProductChart.removeAll()
                    self?.resultzproductOrder.removeAll()
                    self?.reloadCollectionView?()
                    completion()
                    return
                }
                
                self?.resultProductChart = products.reversed()
                
                self?.resultOrderInfo = result.data.order_info
                
//                self?.totalPrice = result.data.order_info.total
                self?.resultzproductOrder.removeAll()
                products.forEach { productChart in
                    let dataProduct = DataProduct(id: productChart.id, quantity: productChart.quantity)
                    self?.resultzproductOrder.append(dataProduct)
                }
            }
            completion()
        }
    }
    
}
