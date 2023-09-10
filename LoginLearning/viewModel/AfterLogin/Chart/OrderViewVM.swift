//
//  OrderViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class OrderViewVM {
    
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
    
    func loadAdress(completion: @escaping((GetAllAdres) -> Void)) {
        getAdress { adress in
            DispatchQueue.main.async {
                self.resultAdress.data = adress.data.reversed()
            }
            completion(adress)
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
        getAllSize { sizen in
            DispatchQueue.main.async {
                self.resultAllSize = sizen!.data
                completion()
            }
        } onError: { error in
            print(error)
        }
    }
    
    func  loadProductChart(completion: @escaping (() -> Void)) {
        getAllChart { result in
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
        } onError: { erorr in
            print(erorr)
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
    
    func getAllSize(completion: @escaping((AllSize?) -> Void), onError: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.size.url) else {return}
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }

            if httpRespon.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(AllSize.self, from: data)
                    completion(result)
                } catch {
                    print(error)
                }
            } else {
                guard let getFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else { return }
                onError(getFailed.description)
            }
        }
        task.resume()
    }
    
    func getAllChart(completion: @escaping((AllChart?) -> Void), onError: @escaping(String) -> Void)  {
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
                    completion(result)
                } catch {
                    print(error)
                }
            } else {
                guard let getFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else { return }
                onError(getFailed.description)
            }
        }
        task.resume()
    }
    
    func deletProductChart(idProduct: Int, idSize: Int, completion: @escaping((String) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else {return}
            print("kode delete:  \(httpRespon.statusCode)")
            if httpRespon.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(WishlistRespon.self, from: data)
                    completion(result.data)
                } catch {
                    print("error delete")
                }
            }
        }
        task.resume()
    }
    
    func putProductChart(idProduct: Int, idSize: Int, completion: @escaping(DataChart?) -> Void, onError: @escaping (String) -> Void)  {
        guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else {return}
            print("Kode pur \(httpRespon.statusCode)")
            if httpRespon.statusCode != 200 {
                onError("\(error)")
                return
            }
            if let result = try? JSONDecoder().decode(ChartUpdateCell.self, from: data) {
                completion(result.data)
            } else if let result = try? JSONDecoder().decode(ResponPut.self, from: data) {
                onError(result.status)
            }
        }
        task.resume()
    }
    
    func postChart(idProduct: Int, idSize: Int, completion: @escaping((Int?) -> Void)) {
            guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let accesToken = KeychainManager.shared.getTokenValid()
            request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpRespon = response as? HTTPURLResponse else { return}
                guard let data = data else {return}
                
                if httpRespon.statusCode == 201 {
                    do {
                        let result = try JSONDecoder().decode(ChartUpdateCell.self, from: data)
                        completion(result.data?.quantity)
                    } catch {
                        print("Gagal Add Chart")
                    }
                }
                

            }
            task.resume()
        }

    
    func postChecOut(product: [DataProduct], address_id: Int, onError: @escaping (String) -> Void) {
        
        guard let url = URL(string: Endpoints.Gets.chekOut.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let checkoutBody = CheckoutBody(products: product, addressId: address_id, bank: "bni")
            let encoder = JSONEncoder()
            let json = try encoder.encode(checkoutBody)
            request.httpBody = json
        } catch {
            print("Error checkOut riview data JSON")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            print("iniiii cekout : \(httpRespon.statusCode)")

            if httpRespon.statusCode != 201 {
                guard let createFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("addRiview Failed")
                    return
                }
                onError(createFailed.description)
                return
            }
        }
        task.resume()
    }
    
}
