//
//  OrderPopUpVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class OrderPopUpVM {
    
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
    
    func getAdress (completion: @escaping((GetAllAdres) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.adress.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            do {
                let result = try JSONDecoder().decode(GetAllAdres.self, from: data)
                self.resultAdress.data = result.data.reversed()
                completion(result)
            } catch {
                print("get Wishlist failed; \(error)")
            }
        }
        task.resume()
    }
    
    func getAllChart(completion: @escaping((AllChart?) -> Void))  {
        guard let url = URL(string: Endpoints.Gets.allChart.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            
            print(httpRespon.statusCode)
            if httpRespon.statusCode == 200 {
                do {
                    //untuk liat bentuk JSON
//                    let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    print(serializedJson)
                    let result = try JSONDecoder().decode(AllChart.self, from: data)
                    self.resultOrderInfo = result.data.order_info
                    completion(result)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
}
