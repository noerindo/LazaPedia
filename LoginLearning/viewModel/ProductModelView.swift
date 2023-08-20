//
//  ProductModelView.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 19/08/2566 BE.
//

import Foundation


class ProductModelView {
    var resultBrand =  AllBrand(description: [Brand]())
    var resultProduct = ProductAll(data: [ProducList]())
    var detailProductVC: DetailViewController?
    var isSearchBar: Bool = false
    var textSearch: String = ""
    var produkFilter = ProductAll(data: [ProducList]())
    
    // deklasi delegatenya
    weak var delegate: ProductTableViewCellDelegate?
    
    var productsCount: Int {
        get {
            return resultProduct.data.count
        }
    }
    
    var brandCount: Int {
        get {
            return resultBrand.description.count
        }
    }
    
    var productFilterCount: Int {
        get {
            return produkFilter.data.count
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
    
    func loadBrand(completion: @escaping (() -> Void)) {
        getBrand { result in
            DispatchQueue.main.async {
                self.resultBrand = result
            }
            completion()
        }
    }
    
    func loadDetail(id: Int) {
        getDetailProduct(id: id) { product in
            let resultProductDetail = product
            DispatchQueue.main.async { [self] in
                guard let unwrappedVC = detailProductVC else { return }
                unwrappedVC.nameProduk.text = product.data.name
                unwrappedVC.priceProduk.text = "$ \(product.data.price)"
                unwrappedVC.descProduc.text = product.data.description
                unwrappedVC.categoryView.text = product.data.category.category
                let imgURL = URL(string: "\(product.data.image_url)")
                unwrappedVC.photoProduc.sd_setImage(with: imgURL)
                
            }
        }
    }
    
//    func getSearchProduct(name: String, completion: @escaping((ProductAll) -> Void)) {
//        guard let url = URL(string: Endpoints.Gets.searchProduct(name: name).url) else { return }
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else { return }
//            do {
//                let result = try JSONDecoder().decode(ProductAll.self, from: data)
//                completion(result)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
        
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
                let result = try JSONDecoder().decode(ProductDetail.self, from: data)
                completion(result)
            } catch {
                print(error)
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
    
}
