//
//  OrderPopUpVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class OrderPopUpVM {
    let networkAPI = NetworkAPI()
    var resultOrderInfo: OrderInfo?
    var resultAdress = GetAllAdres(data: [DataAdress]())
    var cardList = [Card]()
    
    private lazy var cardDataManager: CardDataManager = {
        return CardDataManager()
    }()
    
    func loadCard(completion: @escaping (() -> Void)) {
        self.cardDataManager.getCard { card in
            DispatchQueue.main.async {
                self.cardList.removeAll()
                self.cardList.append(contentsOf: card)
            }
            completion()
        }
    }
    
    func loadAdress(completion: @escaping((GetAllAdres) -> Void)) {
        networkAPI.getAdress { [weak self] adress in
            //supaya app tidak berat
            DispatchQueue.main.async { [weak self] in
                let Primary = adress.data.filter { $0.is_primary != nil}
                let unPrimary = adress.data.filter { $0.is_primary == nil}
                self?.resultAdress.data = Primary + unPrimary
                //ngeset secara explisit
                completion(adress)
            }
        }
    }
    
}
