//
//  OrderViewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import Foundation

class OrderViewModel {
    
    var resultProductChart = [ProductChart]()
    var resultAllSize = [Size]()
    var resultOrderInfo: OrderInfo?
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
            DispatchQueue.main.async {
                self.resultProductChart = (result?.data.products.reversed())!
                self.resultOrderInfo = result!.data.order_info
            }
            completion()
        } onError: { erorr in
            print(erorr)
        }
    }
    
    
    func putProductChart(idProduct: Int, idSize: Int) {
        guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else {return}
            print("kode put:  \(httpRespon.statusCode)")
            
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
    
    func postChart(idProduct: Int, idSize: Int, completion: @escaping((ChartPost?) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            do {
                let result = try JSONDecoder().decode(ChartPost.self, from: data)
                completion(result)
            } catch {
                print("Gagal Add Chart")
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
    
}

