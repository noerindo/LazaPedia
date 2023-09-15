//
//  WishlistVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 22/08/2566 BE.
//

import Foundation

class WishlistVM {
    let networkAPI = NetworkAPI()
    var listWishlist = [ProducList]()
    
    var reloadCollectionView: (() -> Void)?
    
    func loadWishList(completion: @escaping ((WishlistList?) -> Void)) {
        networkAPI.getWishlist { result in
            DispatchQueue.main.async {
                guard let data = result?.data.products else {
                    self.listWishlist.removeAll()
                    self.reloadCollectionView?()
                    return
                }
                self.listWishlist.removeAll()
                self.listWishlist.append(contentsOf: data)
                self.reloadCollectionView?()
                return
            }
            completion(result)
        }
    }
        
    
    
}
