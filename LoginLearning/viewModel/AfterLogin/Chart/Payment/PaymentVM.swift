//
//  PaymentVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class PaymentVM {
    
    var cardList = [Card]()
    private lazy var cardDataManager: CardDataManager = {
        return CardDataManager()
    }()
    
    var cardCount: Int {
        get {
            return cardList.count
        }
    }
    
    func loadCard(completion: @escaping (() -> Void)) {
        self.cardDataManager.getCard { card in
            DispatchQueue.main.async {
                self.cardList.removeAll()
                self.cardList.append(contentsOf: card)
            }
            completion()
        }
    }
    
    func deleteCard( creditCard: Card, completion: @escaping((String) -> Void)) {
        cardDataManager.deleteCard(creditCard) { result in
            completion(result)
        }
    }
}
