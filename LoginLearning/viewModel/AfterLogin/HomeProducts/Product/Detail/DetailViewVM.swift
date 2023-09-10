//
//  DetailViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class DetailViewVM {
    
    var sizeProduct = [Size]()
    var listWishlist = [ProducList]()
    var riviewProduct = [ReviewProduct]()
    var resultDetail: ProductDetail?
    
    private(set) var idProduct: Int
    
    init(idProduct: Int ) {
        self.idProduct = idProduct
    }
    
    var idSize: Int = 0
    
    var sizeCount: Int {
        get {
            return sizeProduct.count
        }
    }
    
    func loadDetail(id: Int, completion: @escaping (() -> Void)) {
        getDetailProduct(id: id) { productDetail in
            DispatchQueue.main.async { [self] in
                self.resultDetail = productDetail
                sizeProduct.append(contentsOf: productDetail.data.size)
                riviewProduct.append(contentsOf: productDetail.data.reviews)
            }
            completion()
        }
    }
    
    func loadWishList(completion: @escaping ((WishlistList) -> Void)) {
        getWishlist { result in
            DispatchQueue.main.async {
                guard let data = result.data.products else {return}
                self.listWishlist.removeAll()
                self.listWishlist.append(contentsOf: data)
            }
            completion(result)
        }
    }
    
    func putWishlist(id: Int, completion: @escaping(String) -> Void) {
        guard let url = URL(string: Endpoints.Gets.addWishList(idProduct: id).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(WishlistRespon.self, from: data)
                //                result.data.reviews = result.data
                completion(result.data)
            } catch {
                print("riview Gagal: \(error)")
            }
        }
        task.resume()
    }
    
    
    
    func getWishlist(completion: @escaping((WishlistList) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.wishlistAll.url) else {return}
        var request = URLRequest(url: url)
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data is nil")
                return
            }
            do {
                let result = try JSONDecoder().decode(WishlistList.self, from: data)
                completion(result)
            } catch {
                print("get Wishlist failed; \(error)")
            }
        }
        task.resume()
    }
    
    func getDetailProduct(id: Int, completion: @escaping((ProductDetail) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.producDetail(id: id).url) else { return }
        let request = URLRequest(url: url)
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                //untuk liat bentuk JSON
//                            let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                            print(serializedJson)
                let result = try JSONDecoder().decode(ProductDetail.self, from: data)
                completion(result)
            } catch {
                print("ini erro loh\(error)")
            }
        }
        task.resume()
    }
    
    func postChart(idProduct: Int, idSize: Int, completion: @escaping((ChartUpdateCell?) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getTokenValid()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            do {
                let result = try JSONDecoder().decode(ChartUpdateCell.self, from: data)
                completion(result)
            } catch {
                print("Gagal Add Chart")
            }
        }
        task.resume()
    }
    
}
