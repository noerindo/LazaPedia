//
//  CardDataManager.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 03/09/2566 BE.
//

import CoreData
import UIKit

class CardDataManager{
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // create card
    func createCard(_ card: Card ) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let cardEntity = NSEntityDescription.entity(forEntityName: "CardData", in: context)
        
        let addCard = NSManagedObject(entity: cardEntity!, insertInto: context)
        addCard.setValue(card.nameCard, forKey: "nameCard")
        addCard.setValue(card.numberCard, forKey: "numberCard")
        addCard.setValue(card.cvv, forKey: "cvvCard")
        addCard.setValue(card.expMonCard, forKey: "expMonCard")
        addCard.setValue(card.expYearCard, forKey: "expYearCard")
        
        do {
            try context.save()
            print("save")
        } catch {
            print("eror create card \(error)")
        }
        
    }
    
    //read
    func getCard(completion: @escaping (_ card: [Card]) -> Void) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CardData")
        
        do {
            let results = try context.fetch(fetchRequest)
            var cards: [Card] = []
            for result in results {
                let card = Card(nameCard: result.value(forKey: "nameCard") as? String ?? "",
                                numberCard: result.value(forKey: "numberCard") as? String ?? "",
                                expMonCard: result.value(forKey: "expMonCard") as? String ?? "",
                                cvv: result.value(forKey: "cvvCard") as? String ?? "",
                                expYearCard: result.value(forKey: "expYearCard") as? String ?? ""
                                )
                cards.append(card)
            }
            completion(cards)
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    // delete
    func deleteCard(_ numberCard: String, completion: @escaping((String)) -> Void) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CardData")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "numberCard = %@", numberCard)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult =
                try? context.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion("hapus berhasil: \(numberCard)")
                print("hapus berhasil: \(numberCard)")
            }
        }
    }
     //update
    func updateCard(_ card: Card, _ numberCard: String) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CardData")
            fetchRequest.predicate = NSPredicate(format: "numberCard = %@", numberCard)
            if let results = try? context.fetch(fetchRequest) {
                do {
                    var _: NSManagedObject?
                    for index in 0..<results.count {
                        let dataToUpdate = results[index]
                        dataToUpdate.setValue(card.nameCard, forKeyPath: "nameCard")
                        dataToUpdate.setValue(card.numberCard, forKeyPath: "numberCard")
                        dataToUpdate.setValue(card.cvv, forKey: "cvvCard")
                        dataToUpdate.setValue(card.expMonCard, forKey: "expMonCard")
                        dataToUpdate.setValue(card.expYearCard, forKey: "expYearCard")
                    }
                    try context.save()
                } catch {
                    print("error update card")
                }
            }
        } 
    }
}
