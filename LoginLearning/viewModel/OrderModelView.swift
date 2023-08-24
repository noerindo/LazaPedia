//
//  OrderModelView.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import Foundation

func postChart(idProduct: Int, idSize: Int, completion: @escaping((ChartPost?) -> Void)) {
    let param = [
        "ProductId": idProduct,
        "SizeId": idSize
    ]
    guard let url = URL(string: Endpoints.Gets.chart(idProduct: idProduct, idSize: idSize).url) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let accesToken = KeychainManager.shared.getToken()
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
    task
    
    
}
