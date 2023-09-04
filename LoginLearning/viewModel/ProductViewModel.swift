//
//  ProductViewModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 19/08/2566 BE.
//

import Foundation

class ProductViewModel {
    var resultBrand =  AllBrand(description: [Brand]())
    var resultProduct = ProductAll(data: [ProducList]())
    var resultBrandProduct = ProductAll(data: [ProducList]())
    var sizeProduct = [Size]()
    var riviewProduct = [ReviewProduct]()
    var isSearchBar: Bool = false
    var textSearch: String = ""
    var resultDetail: ProductDetail?
    
    // deklasi delegatenya
    weak var delegate: ProductTableViewCellDelegate?
    
    var productsCount: Int {
        get {
            return resultProduct.data.count
        }
    }
    var allBrandProductCount: Int {
        get {
            return resultBrandProduct.data.count
        }
    }
    
    var brandCount: Int {
        get {
            return resultBrand.description.count
        }
    }
    
    var sizeCount: Int {
        get {
            return sizeProduct.count
        }
    }
    
    
    func loadProductAll(completion: @escaping (() -> Void)) {
        getProducAll { result in
            DispatchQueue.main.async {
                self.resultProduct = result
            }
            completion()
        }
    }
    
    func loadBrandProductAll(nameBrand: String, completion: @escaping (() -> Void)) {
        getBrandProduct(nameBrand: nameBrand) { data in
            DispatchQueue.main.async {
                self.resultBrandProduct = data
            }
            completion()
        }
    }
    
    
    func loadBrand(completion: @escaping (() -> Void)) {
        getBrand { result in
            DispatchQueue.main.async {
                self.resultBrand = result
            }
            completion()
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
    
        
    func getProducAll(completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.productAll.url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(ProductAll.self, from: data)
                completion(result)
            } catch {
                print(error)
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
    
    func getBrand(completion: @escaping ((AllBrand) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.brandAll.url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(AllBrand.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func getBrandProduct(nameBrand: String, completion: @escaping((ProductAll) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.brandProduct(nameBrand: nameBrand).url) else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(ProductAll.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
