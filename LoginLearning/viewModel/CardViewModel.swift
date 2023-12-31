//
//  CardViewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 04/09/2566 BE.
//

import Foundation

class CardViewModel{
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
    
    func deleteCard( numberCard: String, completion: @escaping((String) -> Void)) {
        cardDataManager.deleteCard(numberCard) { result in
            completion(result)
        }
    }
    
}
