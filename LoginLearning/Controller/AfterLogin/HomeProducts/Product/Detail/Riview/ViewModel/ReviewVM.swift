//
//  ReviewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class ReviewVM{
    let networkAPI = NetworkAPI()
    var listRiview = [ReviewProduct]()
    var resultRiview: DataIdRiview?
    
    private(set) var idProduct: Int
    
    var reloadTableView: (() -> Void)?
    
    init(idProduct: Int) {
        self.idProduct = idProduct
    }
    
    var riviewAllCount: Int {
        get {
            return listRiview.count
        }
    }
    
    func loadAllriviewl(completion: @escaping (() -> Void)) {
        listRiview.removeAll()
        networkAPI.getAllRiview(id: idProduct) { result in
            DispatchQueue.main.async { [self] in
                resultRiview = result.data
                var sortedResult = result
                sortedResult.data.reviews = result.data.reviews.sorted { $0.created_at > $1.created_at } // Sort by created at
                listRiview.append(contentsOf: sortedResult.data.reviews)
                reloadTableView?()
                return
            }
            completion()
        }
    }
}
