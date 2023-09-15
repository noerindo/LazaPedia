//
//  AdressViewVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class AdressViewVM {
   
    let networkAPI = NetworkAPI()
    var resultAdress = GetAllAdres(data: [DataAdress]())
    
    var adressCount: Int {
        get {
            return resultAdress.data.count
        }
    }
    
    func loadAdress(completion: @escaping((GetAllAdres) -> Void)) {
        networkAPI.getAdress { [weak self] adress in
            //supaya app tidak berat
            DispatchQueue.main.async { [weak self] in
                let Primary = adress.data.filter { $0.is_primary != nil}
                let unPrimary = adress.data.filter { $0.is_primary == nil}
                self?.resultAdress.data = Primary + unPrimary
                //ngeset secara explisit
                completion(adress)
            }
        }
    }
    
    
}
