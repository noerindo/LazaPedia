//
//  DetailViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class DetailViewVM {
    let networkAPI = NetworkAPI()
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
        networkAPI.getDetailProduct(id: id) { productDetail in
            DispatchQueue.main.async { [self] in
                //weak self
                self.resultDetail = productDetail
                sizeProduct.append(contentsOf: productDetail.data.size)
                riviewProduct.append(contentsOf: productDetail.data.reviews)
            }
            completion()
        }
    }
    
    func loadWishList(completion: @escaping ((WishlistList) -> Void)) {
        networkAPI.getWishlist { result in
            guard let result = result else {return}
            DispatchQueue.main.async {
                guard let data = result.data.products else {return}
                self.listWishlist.removeAll()
                self.listWishlist.append(contentsOf: data)
            }
            completion(result)
        }
    }
}
