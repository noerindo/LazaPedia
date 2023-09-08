//
//  WishlistVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 22/08/2566 BE.
//

import Foundation

class WishlistVM {
    var listWishlist = [ProducList]()
    
    func loadWishList(completion: @escaping ((WishlistList) -> Void)) {
        getWishlist { result in
            DispatchQueue.main.async {
                self.listWishlist.removeAll()
                self.listWishlist.append(contentsOf: result.data.products)
            }
            completion(result)
        }
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
    
}