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
    var sizeProduct = [Size]()
    var riviewProduct = [ReviewProduct]()
    var isSearchBar: Bool = false
    var textSearch: String = ""
    
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
    
    func loadBrand(completion: @escaping (() -> Void)) {
        getBrand { result in
            DispatchQueue.main.async {
                self.resultBrand = result
            }
            completion()
        }
    }
    
    func loadDetail(id: Int) {
        getDetailProduct(id: id) { productDetail in
            DispatchQueue.main.async { [self] in
                
                guard let unwrappedVC = detailProductVC else { return }
                unwrappedVC.nameProduk.text = productDetail.data.name
                unwrappedVC.priceProduk.text = "$ \(productDetail.data.price)".formatDecimal()
                unwrappedVC.descProduc.text = productDetail.data.description
                unwrappedVC.categoryView.text = productDetail.data.category.category
                let imgURL = URL(string: "\(productDetail.data.image_url)")
                unwrappedVC.photoProduc.sd_setImage(with: imgURL)
                
                sizeProduct.append(contentsOf: productDetail.data.size)
                unwrappedVC.collectionSize.reloadData()
                
                riviewProduct.append(contentsOf: productDetail.data.reviews)
                unwrappedVC.dateUser.text = productDetail.data.reviews[0].created_at.dateReview(date: "\(productDetail.data.reviews[0].created_at)")
                unwrappedVC.ratingText.text = "\(productDetail.data.reviews[0].rating)"
                unwrappedVC.starRating.rating =  productDetail.data.reviews[0].rating
                unwrappedVC.nameUser.text = productDetail.data.reviews[0].full_name
                unwrappedVC.textRiview.text = productDetail.data.reviews[0].comment
                let imgURLUser = URL(string: "\(productDetail.data.reviews[0].image_url)")
                unwrappedVC.photoProfil.sd_setImage(with: imgURLUser)
            }
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
    
}
